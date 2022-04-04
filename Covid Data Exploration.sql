SELECT *
FROM Covid..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM Covid..CovidVaccinations
Where continent is not null
order by 3,4

SELECT Location, date, total_cases,  new_cases, total_deaths, population
FROM Covid..CovidDeaths
ORDER BY 1,2


--Total Cases vs Total Deaths

SELECT Location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Covid..CovidDeaths
WHERE Location like '%state%'
Order by 1,2

--Percentage of population infected.

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Covid..CovidDeaths
--Where location like '%states%'
order by 1,2



--Countries With Highest Infection Rate compared to Population

 SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected 
 FROM Covid..CovidDeaths
 GROUP BY Location, population
 order by 1,2


 -- Total Death Count

 SELECT Location , MAX(CAST(total_deaths AS int)) as TotalDeathCount
 FROM Covid..CovidDeaths
 GROUP BY Location
 order by TotalDeathCount DESC

 --Countries with highest Death Count Per Population

 SELECT location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
 FROM Covid..CovidDeaths
 WHERE continent is Null
 GROUP BY location
 order by TotalDeathCount DESC


 --Breaking Things Down By Continent
SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM Covid..CovidDeaths
WHERE continent is not null
GROUP BY date
order by 1,2


--Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 as DeathPercentage
FROM Covid..CovidDeaths
WHERE continent is not null
GROUP BY date
order by 1,2

--Joining Tables

SELECT *
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date


SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
order by 1,2,3


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent,Location , Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac 
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


--Using Temp Table to perform calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)
INSERT into #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
--WHERE dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated
Order by 2,3



