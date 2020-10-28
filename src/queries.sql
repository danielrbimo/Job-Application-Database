use job;

-- employed and unemployed workforce based on industry
select tmp.voc_school_specialty, total_employed_workforce, total_unemployed_workforce
from (
select voc_school_specialty, count(profile.profile_id) as total_employed_workforce
from profile
join voc_school on (voc_school.voc_school_id = profile.voc_school_id)
where is_employed = true
group by voc_school_specialty) as tmp
join
(select voc_school_specialty, count(profile.profile_id) as total_unemployed_workforce
from profile
join voc_school on (voc_school.voc_school_id = profile.voc_school_id)
where is_employed = false
group by voc_school_specialty) as tmp2
on tmp.voc_school_specialty = tmp2.voc_school_specialty;

-- employed and unemployed workforce based on province
select tmp2.province, total_employed_workforce, total_unemployed_workforce
from (
select profile.province, count(profile.profile_id) as total_employed_workforce
from profile
where is_employed = true
group by profile.province) as tmp
right join (
select profile.province, count(profile.profile_id) as total_unemployed_workforce
from profile
where is_employed = false
group by profile.province) as tmp2
on tmp.province = tmp2.province;


-- How many suitable candidates are there for the open positions in the job market?
select industry, skill_level, open_positions, num_candidates
from 
(select industry, job_posting.skill_level, sum(no_positions_open) as open_positions
from job_posting
join company on (job_posting.company_id = company.company_id)
group by industry, job_posting.skill_level) as tmp
left join (
select voc_school_specialty, voc_school.voc_school_quality, count(profile.profile_id) as num_candidates
from profile
join voc_school on (voc_school.voc_school_id = profile.voc_school_id)
where profile.is_employed = false
group by voc_school_specialty, voc_school_quality) as tmp2 on (tmp.industry = tmp2.voc_school_specialty and tmp.skill_level = tmp2.voc_school_quality);

-- Who are the employed workers that have a mismatch in skills?
select profile.first_name, profile.last_name, industry, position, skill_level as required_skill_level, voc_school.voc_school_quality as actual_skill_level
from profile
join 
(select position, profile_id, skill_level, industry
from acceptance
join job_posting on (acceptance.job_posting_id = job_posting.job_posting_id)
join company on (job_posting.company_id = company.company_id)
where acceptance.status = true) as temp
on temp.profile_id = profile.profile_id
join voc_school
on profile.voc_school_id = voc_school.voc_school_id
where skill_level <> voc_school_quality;

-- TRIGGER
DROP TRIGGER IF EXISTS employee_hired;
DELIMITER //

create trigger employee_hired
    after update on acceptance
    for each row
begin

	if (old.status = false or old.status is null and new.status = true) then
    update profile
    set is_employed = true
    where new.profile_id = profile.profile_id;
    
    update job_posting
    set no_positions_open = no_positions_open - 1
    where new.job_posting_id = job_posting.job_posting_id;
    
    update job_posting
    set job_posting_status = false
    where new.job_posting_id = job_posting.job_posting_id and job_posting.no_positions_open = 0;
    end if;
	
    
end //

DELIMITER ;
	
-- Trigger Test
-- Before position: 1
update acceptance
set status = true
where profile_id = 23 and job_posting_id = 1;

select*
from job_posting
