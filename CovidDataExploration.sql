SELECT continent, location, date, population, total_cases,total_deaths FROM MyportfolioProjects..Coviddeaths$
SELECT location, date, total_cases FROM MyportfolioProjects..Coviddeaths$ WHERE location = 'India' ORDER BY total_cases DESC

--Maximum number of cases in India, Bangladesh, Pakistan
SELECT location, max(new_cases) FROM MyportfolioProjects..Coviddeaths$ WHERE location = 'Pakistan' or location = 'Bangladesh' or location = 'India' GROUP BY new_cases, location ORDER BY new_cases DESC, location 
SELECT max(new_cases) as newcasespak FROM MyportfolioProjects..Coviddeaths$ WHERE location = 'Pakistan' 
SELECT max(new_cases) as newcasesind FROM MyportfolioProjects..Coviddeaths$ WHERE location = 'India'
SELECT * FROM MyportfolioProjects..Coviddeaths$ WHERE location like '%states' ORDER BY new_cases DESC

-- Percentage of the population who has been infected
SELECT location, date, (total_cases/population) * 100 as percentage_population_infected FROM MyportfolioProjects..Coviddeaths$ WHERE location like '%states' ORDER BY percentage_population_infected DESC

----Death percentage due to covid in united states

SELECT location, date, (total_deaths/population)* 100 as deathpercentage FROM MyportfolioProjects..Coviddeaths$ WHERE location like '%states' ORDER BY deathpercentage DESC

--Percentage of the population infected in each continent

SELECT date, continent , (total_cases/population)*100 as percentagepopulationbycontinent FROM MyportfolioProjects..Coviddeaths$ WHERE continent like '%america'  ORDER BY percentagepopulationbycontinent DESC

--continent with high infectious rates

SELECT continent, population, max(total_cases) as highinfectiousrate, max((total_cases/population)*100) as percentagepoulationinfected FROM MyportfolioProjects..Coviddeaths$ GROUP BY continent, population ORDER BY percentagepoulationinfected DESC

--Continents with highest death count

SELECT continent, max(total_deaths), sum(cast(total_deaths as int)) as totaldeaths FROM MyportfolioProjects..Coviddeaths$  WHERE continent IS NOT NULL GROUP BY continent,total_deaths

--Total number of deaths across all countries
SELECT max(cast(total_deaths as int)) FROM MyportfolioProjects..Coviddeaths$ WHERE total_deaths IS NOT NULL

-- SELECT BY CONTINET

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount FROM MyportfolioProjects..Coviddeaths$ WHERE continent IS NOT NULL GROUP BY continent ORDER BY TotalDeathCount DESC

--Get the total number of cases and total number of deaths across the globe

SELECT SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths FROM MyportfolioProjects..Coviddeaths$ WHERE continent IS NOT NULL ORDER BY 1,2

--or 
SELECT sum(total_cases) as TotalCases , SUM(CAST(total_deaths as int)) as TotalDeaths FROM MyportfolioProjects..Coviddeaths$ WHERE continent IS NOT NULL ORDER BY 1,2

-- SHOW THE VACCINATION TABLE

SELECT * FROM MyportfolioProjects..CovidVaccinations$

SELECT  max(people_vaccinated) FROM MyportfolioProjects..CovidVacinations$

SELECT dea.location, dea.population, vac.total_vaccinations FROM MyportfolioProjects..Coviddeaths$ dea 
JOIN MyportfolioProjects..CovidVaccinations$ vac ON dea.location = vac.location  AND dea.date = vac.date WHERE dea.continent IS NOT NULL ORDER BY vac.total_vaccinations DESC

SELECT dea.location,dea.date,vacc.tests_per_case,dea.total_cases, vacc.total_vaccinations FROM MyportfolioProjects..Coviddeaths$ dea FULL OUTER JOIN  MyportfolioProjects..CovidVaccinations$ vacc
ON dea.location = vacc.location AND dea.date = vacc.date WHERE dea.continent IS NOT NULL ORDER BY 3 DESC, 4 DESC