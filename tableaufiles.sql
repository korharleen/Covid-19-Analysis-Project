
------------------------------ Queries used for Tableau Project------------------------------------------------------------------------------------------




--------------------------------------------------------------- 1. Global Numbers---------------------------------------------------------------------------

Select SUM(new_cases) as total_cases, 
       SUM(new_deaths::int) as total_deaths, 
       SUM(new_deaths::decimal)/SUM(New_Cases)*100 as DeathPercentage
From Coviddeaths
--Where location like 'India'
where continent is not null 
--Group By dt
order by 1,2




-------------------------------------------------------------- 2. -----------------------------------------------------------------------------------------

------------------------------------ We take these out as they are not inluded in the above queries and want to stay consistent
----------------------------------------- European Union is part of Europe
----------------------------------------- I have some additional information regarding incomes so removing for the time being

Select location, 
      SUM(cast(new_deaths as int)) as TotalDeathCount
      From CovidDeaths
--Where location like '%india%'
Where continent is null 
and location not in ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc


-------------------------------------------------- 3. InfectedPercentagge against population grouping as per location and population-----------------------


Select Location,population,
       MAX(total_cases) as HighestInfectionCount,
       Max(total_cases/population)*100 as percentpopulationInfected
From CovidDeaths
--Where location like 'India'
--WHERE continent is not null 
Group by location,population
order by PercentPopulationInfected desc



------------------------------------------------ 4. InfectedPercentagge against population grouping as per location ,population,dt-------------------------


Select Location, Population,dt,
       MAX(total_cases) as HighestInfectionCount, 
       Max((total_cases::decimal/population))*100 as PercentPopulationInfected
From CovidDeaths
Where location not like 'International'
Group by Location, Population, dt
order by PercentPopulationInfected desc


-- Queries I originally had are in the projectporfolio.sql attached

