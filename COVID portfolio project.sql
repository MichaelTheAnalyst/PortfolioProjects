select * 
from CovidDeaths$
where continent is not null
order by 3,4

--select * 
--from CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2
 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from CovidDeaths$
where location like '%iran%'
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from CovidDeaths$
where location like '%iran%'
order by 1,2


select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage 
from CovidDeaths$
where location like '%iran%'
order by 1,2



select location, population, max(total_cases) as HighestInectionCount , max((total_cases/population))*100 as CasePercentage 
from CovidDeaths$
--where location like '%iran%'
group by location , population
order by 4 desc




select location, max(cast(total_deaths as int)) as TotalDeathsCount 
from CovidDeaths$
--where location like '%iran%'
where continent is not null
group by location 
order by 2 desc

select continent, max(cast(total_deaths as int)) as TotalDeathsCount 
from CovidDeaths$
--where location like '%iran%'
where continent is not null
group by continent 
order by 2 desc



select location , max(cast(total_deaths as int)) as TotalDeathsCount 
from CovidDeaths$
--where location like '%iran%'
where continent is  null
group by location 
order by 2 desc


select continent , max(cast(total_deaths as int)) as TotalDeathsCount 
from CovidDeaths$
--where location like '%iran%'
where continent is  null
group by continent 
order by 2 desc





select date, sum(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as TotalNewDeath, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths$
--where location like '%iran%'
where continent is  not null
group by date 
order by 1 



select sum(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as TotalNewDeath, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths$
--where location like '%iran%'
where continent is  not null
order by 1 


Select * 
From CovidVaccinations$


Select * 
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date

	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
order by 2,3


	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
order by 2,3


with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage
From PopvsVac
--where location like '%iran%'

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
New_vaccionations numeric, 
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is  not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage
From #PercentPopulationVaccinated 

create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea 
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
--order by 2,3


select * 
from PercentPopulationVaccinated