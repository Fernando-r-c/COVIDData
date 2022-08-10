SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccionations
--ORDER BY 3, 4

--SELECT DATA 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
order by 1,2

--TOTAL CASES VS TOTAL DEATHS -- LIKELIHOOD OF DYING BY LOCATION AND DATE
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPctage
FROM PortfolioProject..CovidDeaths
order by 1,2

--TOTAL CASES VS POPULATION -- PCTAGE OF PEOPLE WITH COVID
SELECT location, MAX(cast((total_deaths) as int)) as DeathCount
FROM PortfolioProject..CovidDeaths
WHERE NOT continent = ''
GROUP BY location
order by DeathCount DESC

--RANKING CONTINENTS BY DEATHS
SELECT location, MAX(cast((total_deaths) as int)) as DeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent = ''
GROUP BY location
order by DeathCount DESC

--,BY COUNTRY
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPctage
FROM PortfolioProject..CovidDeaths
WHERE NOT continent = ''
GROUP BY date
order by DeathPctage DESC

--CREATE VIEW TO STORE DATA FOR LATER
CREATE OR ALTER VIEW PercentPopulationVaccinated AS
SELECT 
		dea.continent, 
		dea.location, 
		dea.date,
		dea.population,
	   vac.new_vaccinations, 
	   SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccionations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE NOT dea.continent = ''