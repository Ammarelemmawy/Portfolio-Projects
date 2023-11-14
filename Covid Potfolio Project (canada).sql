Select*
From [dbo].[CovidDeaths]
Where location like '%canada%'


Select Location, Date, Population, Total_Cases, (total_cases/population)*100 As PercentageofCases
From [dbo].[CovidDeaths]
Where location like '%canada%'
--Order by PercentageofCases

Select Location, Date, Population, MAX(new_cases) as MaXNewCases, (Max(new_cases/population))*100 As PercentageofNew_Cases
From [dbo].[CovidDeaths]
Where location like '%canada%'
Group by Location, Date, Population
Order by MaXNewCases Desc

Select Location,population,Max(New_Cases) as MaxNewCases, (Max(New_Cases/population))*100 as percentCases
From [dbo].[CovidDeaths]
Where location like '%canada%'
Group by Location,population
Order by MaxNewCases Desc

Select Location, Date, Population, New_Deaths, (New_Deaths/population)*100 As PercentageofNew_Deaths
From [dbo].[CovidDeaths]
Where location like '%canada%'
Group by Location, Date, Population,New_Deaths
Order by New_Deaths Desc

Select Location, Population, MAX(New_Deaths) as MaXNewDeaths, (Max(New_Deaths/population))*100 As PercentageofNew_Deaths
From [dbo].[CovidDeaths]
Where location like '%canada%'
Group by Location, Population
Order by MaXNewDeaths Desc



Select Location,Date, Population, Total_Cases, Total_Deaths, (total_deaths/total_cases)*100 As PercentageofDeaths
From [dbo].[CovidDeaths]
Where location like '%canada%'
Order by PercentageofDeaths


Select Location, Date, New_Cases, New_Deaths, isnull(New_Deaths/nullif (New_Cases ,0),0)*100 As DeathsPercentage 
From [dbo].[CovidDeaths]
Where location like '%canada%'
--where continent is not null 
Group by Location, Date, New_Cases, New_Deaths
Order by DeathsPercentage Desc



  Select dea.location, dea.date , dea.population, vac.new_vaccinations, 
Sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea. date) as RollingSumVaccination
From [dbo].[CovidDeaths] dea join [dbo].[CovidVaccination] vac
  on dea.Location = vac.location
  and dea.date = vac.date
  Where dea.location like '%canada%'

  
  with vaccinatedPercentage (location, date, population, new_vaccinations, RollingSumVaccination)
  as
  (
  Select dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as RollingSumVaccination
From [dbo].[CovidDeaths] dea join [dbo].[CovidVaccination] vac
  on dea.Location = vac.location
  and dea.date = vac.date
  Where dea.location like '%canada%'
  )

  Select*, (RollingSumVaccination/population)*100 as VP
  from vaccinatedPercentage


  Or


--  Drop table if Exists VaccinatedPeople
--  Create table VaccinatedPeople
--  ( Lcation nvarchar(255),
--  Date datetime,
--  population float,
--  New_vaccination  nvarchar(255),
--  RollingSumVaccination numeric)

--  Insert into VaccinatedPeople
--  Select dea.location, dea.date, dea.population, vac.new_vaccinations, 
--Sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as RollingSumVaccination
--From [dbo].[CovidDeaths] dea join [dbo].[CovidVaccination] vac
--  on dea.Location = vac.location
--  and dea.date = vac.date
--  Where dea.location like '%canada%'

--  select*, (RollingSumVaccination/population)*100 as VP
--  From VaccinatedPeople


  
Create View PercentPeopleVaccinated as
Select dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as RollingSumVaccination
From [dbo].[CovidDeaths] dea join [dbo].[CovidVaccination] vac
  on dea.Location = vac.location
  and dea.date = vac.date
  Where dea.location like '%canada%'

select*
 From PercentPeopleVaccinated

