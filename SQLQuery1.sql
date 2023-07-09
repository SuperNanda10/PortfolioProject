select *
from CovidDeaths$
order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

--Select the Data that we are going to use

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in our country
select location,date,total_cases,total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from CovidDeaths$
where location='Myanmar'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

select location,date,population,total_cases, (total_cases/population)* 100 as PercentPopulationInfected
from CovidDeaths$
--where location='Myanmar'
order by 1,2

--Looking at country with highest infestion rate compared to population

select location,population,max(total_cases) as HighestInfestionCount, Max((total_cases/population)* 100) as PercentPopulationInfected
from CovidDeaths$
--where location='Myanmar'
group by population,location
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Counts per Population

select location,max(cast(total_deaths as int) )as TotalDeathCount
from CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

select continent,max(cast(total_deaths as int) )as TotalDeathCount
from CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Showing the Continents with Highest Death Counts per Population

select continent,max(cast(total_deaths as int) )as TotalDeathCount
from CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths$
--where location='Myanmar'
where continent is not null
--group by date
order by 1,2 desc

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
from CovidDeaths$ as dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


--USE CTE

with PopvsVac(Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
from CovidDeaths$ as dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(continent nvarchar (255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
from CovidDeaths$ as dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--creating views to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
from CovidDeaths$ as dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated