--SELECT *
--FROM CovidDeaths

--SELECT *
--FROM CovidVaccinations

--SELECT country, date, total_cases,  new_cases, total_deaths, population
--FROM CovidDeaths

--SELECT country, date, total_cases,  new_cases, total_deaths, population
--FROM CovidDeaths
--ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths

--SELECT country, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0)) * 100 AS DeathPercentage
--FROM CovidDeaths
--WHERE country = 'United States'
--ORDER BY 1,2 

-- Looking at Total Cases vs Population
-- Show what percentage of poulation got Covid

--SELECT country, date, population, total_cases,  (total_cases/NULLIF(population, 0)) * 100 AS PercentagePopulationInfected
--FROM CovidDeaths
--WHERE country = 'United States'
--ORDER BY 1,2 

-- Look at countries with highest infection rate compared to population

--SELECT country, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/NULLIF(population, 0))) * 100 AS PercentagePopulationInfected
--FROM CovidDeaths
--GROUP BY country, population
--ORDER BY PercentagePopulationInfected DESC

-- Showing countries with highest death count per population

--SELECT country, MAX(total_deaths) AS TotalDeathCount
--FROM CovidDeaths
--WHERE country NOT IN ('World', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')
--GROUP BY country
--ORDER BY TotalDeathCount DESC

-- Breaking down things by continent

--SELECT country, MAX(total_deaths) AS TotalDeathCount
--FROM CovidDeaths
--WHERE country IN('World', 'Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
--GROUP BY country
--ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

--SELECT MAX(total_cases) AS TotalCases, MAX(total_deaths) AS TotalDeaths, MAX(total_deaths)/MAX(NULLIF(total_cases,0))*100 AS DeathPercentage
--FROM CovidDeaths
----WHERE country = 'United States'
----GROUP BY date
--ORDER BY 1,2


-- Locating at Total Population vs Vaccinations

--SELECT dea.country, dea.date, dea.population, vac.new_vaccinations
--, SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION By dea.country) AS SumVac
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--	ON dea.country = vac.country 
--	AND dea.date = vac.date
--WHERE dea.country NOT IN ('World', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')
--ORDER BY new_vaccinations DESC

--SELECT dea.country, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION By dea.country ORDER BY dea.country, dea.date) AS TotalVac
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--	ON dea.country = vac.country 
--	AND dea.date = vac.date
--WHERE dea.country NOT IN ('World', 'Africa', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')
--ORDER BY 1,2  

-- CTE

--WITH CTE_PopVsVac (country, date, population, new_vaccinations, TotalVac)
--AS
--(
--SELECT dea.country, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION By dea.country ORDER BY dea.country, dea.date) AS TotalVac
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--	ON dea.country = vac.country 
--	AND dea.date = vac.date
--WHERE dea.country NOT IN ('World', 'Africa', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')
--)

--SELECT *, (TotalVac/population)*100 AS RollingPercentage
--FROM CTE_PopVsVac

-- TEMP TABLE

--DROP TABLE IF EXISTS #PerecentPopulationVaccinated 
--CREATE TABLE #PerecentPopulationVaccinated 
--(
--country nvarchar(255),
--date datetime,
--population int,
--new_vaccinations float,
--TotalVac float
--)

--INSERT INTO #PerecentPopulationVaccinated 
--SELECT dea.country, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION By dea.country ORDER BY dea.country, dea.date) AS TotalVac
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--	ON dea.country = vac.country 
--	AND dea.date = vac.date
--WHERE dea.country NOT IN ('World', 'Africa', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')

--SELECT *, (TotalVac/population)*100 AS RollingPercentage
--FROM #PerecentPopulationVaccinated

--Creating views to store to data for later visualizations

--1

CREATE VIEW PerecentPopulationVaccinated AS

SELECT dea.country, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION By dea.country ORDER BY dea.country, dea.date) AS TotalVac
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.country = vac.country 
	AND dea.date = vac.date
WHERE dea.country NOT IN ('World', 'Africa', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')

SELECT *
FROM PerecentPopulationVaccinated

--2 

CREATE VIEW HighestDeathCountPerCountry AS

SELECT country, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE country NOT IN ('World', 'World excl. China', 'World excl. China and South Korea', 'World excl. China, South Korea, Japan and Singapore', 'High-income countries', 'Upper-middle-income countries', 'Europe', 'North America', 'Asia', 'Asia excl. China', 'South America', 'European Union (27)', 'Lower-middle-income countries', 'Low-income countries')
GROUP BY country

SELECT *
FROM HighestDeathCountPerCountry
ORDER BY TotalDeathCount DESC
