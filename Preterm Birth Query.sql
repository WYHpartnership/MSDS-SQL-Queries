--PRETERM BIRTHS ONLY -CTE
WITH PretermBirths AS (
SELECT MSD000.OrgCodeProvider, 
year(MSD401.[REPORTING PERIOD START DATE]) as Years,
month(MSD401.[REPORTING PERIOD START DATE]) as Months,
count (DISTINCT MSD401.Person_ID_Mother) AS Preterm
FROM  [msds].[MSD401BabyDemographics] MSD401 
INNER JOIN  [msds].[MSD000Header] MSD000 ON MSD401.OrgCodeProvider = MSD000.OrgCodeProvider-- AND MSD000.RPEndDate = '{RPEnd}' AND MSD401.RPStartDate BETWEEN '{start}' AND '{end}' 
INNER JOIN  [msds].[MSD301LabourDelivery] MSD301 ON MSD401.UniqPregID=MSD301.UniqPregID-- AND MSD401.RPStartDate=MSD301.RPStartDate
WHERE --(MSD401.PersonBirthDateBaby BETWEEN '{start}' and '{end}') 
--AND 
(MSD401.GestationLengthBirth BETWEEN '154' and '258') 
AND 
(MSD401.Pregoutcome = '01') 
--AND 
--MSD301.BirthsPerLabandDel = 1 
GROUP BY MSD000.OrgCodeProvider,year(MSD401.[REPORTING PERIOD START DATE]),month(MSD401.[REPORTING PERIOD START DATE])
) 

--ALL BIRTHS AND PRETERM CALCULATIONS
Select AllBirths.*,
Preterm,
1000*Preterm/AllBirths as PretermBirthRate
FROM (
--ALL BIRTHS
SELECT MSD000.OrgCodeProvider, 
year(MSD401.[REPORTING PERIOD START DATE]) as Years,
month(MSD401.[REPORTING PERIOD START DATE]) as Months,
count (DISTINCT MSD401.Person_ID_Mother) AS AllBirths

FROM  [msds].[MSD401BabyDemographics] MSD401 
INNER JOIN  [msds].[MSD000Header] MSD000 ON MSD401.OrgCodeProvider = MSD000.OrgCodeProvider
INNER JOIN  [msds].[MSD301LabourDelivery] MSD301 ON MSD401.UniqPregID=MSD301.UniqPregID

WHERE
(MSD401.GestationLengthBirth BETWEEN '154' and '315') 
AND 
(MSD401.Pregoutcome = '01') 
--AND 
--MSD301.BirthsPerLabandDel = 1 

GROUP BY MSD000.OrgCodeProvider,year(MSD401.[REPORTING PERIOD START DATE]),month(MSD401.[REPORTING PERIOD START DATE])
)as AllBirths

LEFT JOIN PretermBirths on PretermBirths.OrgCodeProvider=AllBirths.OrgCodeProvider and PretermBirths.Years=AllBirths.Years and PretermBirths.Months=AllBirths.Months