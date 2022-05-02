SELECT *
FROM Portfolioproject..COVIDdeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM Portfolioproject..COVIDvaccinations
--ORDER BY 3,4

--Selecting the data i'm going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolioproject..COVIDdeaths
ORDER BY 1,2

--Looking at Total cases vs Total deaths
--Shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM Portfolioproject..COVIDdeaths
WHERE location like '%United states%'
ORDER BY 1,2

--Looking at total cases vs population
--Shows what percentage of population got COVID
SELECT location, date, total_cases, (total_cases/population)*100 as population_percentage_infected
FROM Portfolioproject..COVIDdeaths
--WHERE location like '%United states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 as population_percentage_infected
FROM Portfolioproject..COVIDdeaths
--WHERE location like '%United states%'
GROUP BY location, population 
ORDER BY population_percentage_infected DESC

--Looking at death counts per population in each country

SELECT location, MAX(CAST(total_deaths as int)) as total_death_count
FROM Portfolioproject..COVIDdeaths
--WHERE location like '%United states%'
WHERE continent is not null
GROUP BY location 
ORDER BY total_death_count DESC

--Breaking it down by continent

SELECT continent, MAX(CAST(total_deaths as int)) as total_death_count
FROM Portfolioproject..COVIDdeaths
--WHERE location like '%United states%'
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC

--GLOBAL NUMBERS

--To see death total and percentage for the whole world
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as death_percentage
FROM Portfolioproject..COVIDdeaths
--WHERE location like '%United states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location order by dea.location, dea.date)
AS rolling_people_vaccinations
FROM Portfolioproject..COVIDdeaths dea
Join Portfolioproject..COVIDvaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

--Creating views to store data for visualization

create view percent_population_vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location order by dea.location, dea.date)
AS rolling_people_vaccinations
FROM Portfolioproject..COVIDdeaths dea
Join Portfolioproject..COVIDvaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 1,2,3

SELECT *
from percent_population_vaccinated