Select *
From Coviddeaths



------------------------------------------------Selecting some data to work upon----------------------------------------------------------------------

Select Location, dt, total_cases, new_cases, total_deaths, population
From Coviddeaths
Where continent is not null 
order by 1,2



-------------------------------------------------looking at total cases against population--------------------------------------------------------------

-----------March 2020 was major breakdown for india ,jumped straight from 5 cases to 28 and rest is the history

Select Location, dt, total_cases,population,
        (total_cases::numeric/population::numeric)*100 as PercentagePopulationInfected
From CovidDeaths
Where location like 'India'
and continent is not null 
order by 1,2




---------------------------------------------------- Looking at countries with Highest Infection Rate against population-----------------------------------

Select Location,population,MAX(total_cases) as HighestInfectionCount,
       Max(total_cases::numeric/population)*100 as percentpopulationInfected
From CovidDeaths
Where location like 'India'
and continent is not null 
Group by location,population
order by PercentPopulationInfected desc



-----------------------------------------------------Total Cases vs Total Deaths--------------------------------------------------------------------------
-----------------------------------------------------Shows likelihood of dying if you contract covid in your country
----------------------------------------------------There is 1.18 % chance of me dying if i get covid in the month m doing this project

Select Location, dt, total_cases,total_deaths, 
        (total_deaths::numeric/total_cases::numeric)*100 as DeathPercentage
From Coviddeaths
Where location like 'India'
and continent is not null 
order by 1,2





----------------------------------------------------showing Countries with Highest Death Count per population--------------------------------------------

Select Location, 
       MAX(total_deaths) as totalDeathCount
From Coviddeaths
where continent is not null
group by location
order by totalDeathCount desc

-------------------------------------------------------LETS BREAK THINGS BY CONTINENT--------------------------------------------------------------------




------------------------------------------------------ Showing contintents with the highest death count per population------------------------------------

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


------------------------------------------------------------GLOBAL NUMBERS-------------------------------------------------------------------------------

Select SUM(new_cases) as total_cases, SUM(new_deaths::int) as total_deaths, 
       SUM(new_deaths::decimal)/SUM(New_Cases)*100 as DeathPercentage
From Coviddeaths
--Where location like 'India'
where continent is not null 
--Group By dt::date
order by 1,2






---------------------------------------------------------------JOINING WITH COVID_VACCINATIONS------------------------------------------------------------


SELECT *
FROM covid_vaccinations



--------------------------------------------------------------Total Population vs Vaccinations------------------------------------------------------------


------------------------------------Shows Percentage of Population that has recieved at least one Covid Vaccine-------------------------------------------

Select dea.continent, dea.location, dea.dt::date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations::integer) over  (PARTITION BY dea.LOCATION ORDER BY dea.location, dea.dt) as RollingPeopleVaccinated
From Coviddeaths dea
Join Covidvaccinations  vac
	On dea.location = vac.location
	and dea.dt = vac.dt
where dea.continent is not null
order by 2,3



-----------------------------------Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, dt, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.dt, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations::integer) OVER (Partition by dea.Location Order by dea.location, dea.dt) as RollingPeopleVaccinated
From Coviddeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.dt = vac.dt
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated::decimal/Population)*100
From PopvsVac

----------------------------Using Temp Table to perform Calculation on Partition By in previous query -- same thing as above

Create  temporary table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Dt date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into  PercentPopulationVaccinated
Select dea.continent, dea.location, dea.dt, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations::integer) OVER (Partition by dea.Location Order by dea.location, dea.dt) as RollingPeopleVaccinated
From Coviddeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.dt = vac.dt
where dea.continent is not null 

Select *, (RollingPeopleVaccinated::decimal/Population)*100
From PercentPopulationVaccinated

--------------------------------------------------Creating View to store data for later visualizations-----------------------------------------------------

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.dt::date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations::integer) over  (PARTITION BY dea.LOCATION ORDER BY dea.location, dea.dt) as RollingPeopleVaccinated
From Coviddeaths dea
Join Covidvaccinations  vac
	On dea.location = vac.location
	and dea.dt = vac.dt
where dea.continent is not null
order by 2,3


select * from PercentPopulationVaccinated




