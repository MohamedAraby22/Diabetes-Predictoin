

--1. Retrieve the Patient_id and ages of all patients.
select patient_id , datediff ( year , DateBirth , getdate() ) as age
from Diabetes 


--2. Select all female patients who are olderthan 30.
SELECT EmployeeName
FROM Diabetes
WHERE gender = 'Female'  AND DATEADD(year, 30, DateBirth) <= GETDATE()


--3. Calculate the average BMI of patients.
select avg(bmi) 
from diabetes

--4. List patients in descending order of blood glucose levels.
select EmployeeName , blood_glucose_level
from diabetes
order by blood_glucose_level desc

--5. Find patients who have hypertension and diabetes.
select EmployeeName , hypertension , diabetes
from diabetes
where hypertension = 1 and diabetes = 1

--6. Determine the number of patients with heart disease.
select count(patient_id)
from diabetes
where heart_disease = 1
--7. Group patients by smoking history and count how many smokers and nonsmokers there are.
UPDATE diabetes
SET smoking_history =
    CASE
        WHEN smoking_history = 'ever' THEN 'never'
        WHEN smoking_history = 'not current' THEN 'former'
    END
WHERE smoking_history IN ('ever', 'not current')
SELECT smoking_history,
       COUNT(*) AS total_patients,
       CASE
           WHEN smoking_history IN ('former', 'current') THEN COUNT(*)
           ELSE 0
       END AS smokers,
       CASE
           WHEN smoking_history = 'never' THEN COUNT(*)
           ELSE 0
       END AS non_smokers
FROM diabetes
GROUP BY smoking_history


--8. Retrieve the Patient_id of patients who have a BMI greater than the average BMI.

select patient_id , bmi 
from diabetes
where bmi > (select avg(bmi) from diabetes)

--9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.

SELECT TOP 1 WITH TIES Patient_id, HbA1c_level
FROM diabetes
ORDER BY HbA1c_level DESC  

SELECT TOP 1 WITH TIES Patient_id, HbA1c_level
FROM diabetes
ORDER BY HbA1c_level ASC

--10. Calculate the age of patients in years (assuming the current date as of now).
select patient_id , datediff ( year , DateBirth , getdate() ) as age
from Diabetes 

--11. Rank patients by blood glucose level within each gender group.

with bloodglucoselevel
as ( select * , rank() over (partition by gender order by blood_glucose_level) as Ranking
     from diabetes )

	 select patient_id , blood_glucose_level , gender , Ranking
	 from  bloodglucoselevel


---12. Update the smoking history of patients who are olderthan 40 to "Ex-smoker."

update diabetes
set smoking_history = 
                    case
					     when smoking_history = 'current' then 'ex-smoker'
						 when smoking_history = 'former' then 'ex-smoker'
						 end
                    where smoking_history in ('current' , 'former') and DATEADD(year, 40, DateBirth) <= GETDATE()
         
--13. Insert a new patient into the database with sample data.

insert into diabetes values ( 'MOHAMED ARABY' , 'PT22222', 'Male' , '2024-1-1' , 0 , 0 , 'never' , 26 , 5 , 80 , 0)


--14. Delete all patients with heart disease from the database.
DELETE FROM DIABETES
WHERE heart_disease = 1

--15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
select patient_id
from diabetes
where hypertension = 1
except 
select patient_id
from diabetes
where diabetes = 0

--16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE diabetes
ADD CONSTRAINT unique_patient_id UNIQUE (patient_id)


--17. Create a view that displays the Patient_ids, ages, and BMI of patients.

CREATE VIEW V_DIABETES
AS
SELECT patient_id , DateBirth , bmi
from diabetes

--18. Suggest improvements in the database schema to reduce data redundancy and
improve data integrity.
19. Explain how you can optimize the performance of SQL queries on this dataset