---consulta1---
/* Selecciona las columnas DisplayName, Location y Reputation de los usuarios con mayor
reputaci�n. Ordena los resultados por la columna Reputation de forma descendente y
presenta los resultados en una tabla mostrando solo las columnas DisplayName,
Location y Reputation*/
SELECT TOP 200 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

--Consulta 2--
/* Selecciona la columna Title de la tabla Posts junto con el DisplayName de los usuarios
que lo publicaron para aquellos posts que tienen un propietario.
Para lograr esto une las tablas Posts y Users utilizando OwnerUserId para obtener el
nombre del usuario que public� cada post. Presenta los resultados en una tabla
mostrando las columnas Title y DisplayName */
SELECT Posts.Title, Users.DisplayName
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

--Consulta 3--

/* Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName
del usuario junto con el promedio de Score.
Para esto agrupa los posts por OwnerUserId, calcula el promedio de Score para cada
usuario y muestra el resultado junto con el nombre del usuario. Presenta los resultados
en una tabla mostrando las columnas DisplayName y el promedio de Score  */

SELECT Users.DisplayName, AVG(Posts.Score) AS AverageScore
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;


--Consulta 4--

/* Encuentra el DisplayName de los usuarios que han realizado m�s de 100 comentarios
en total. Para esto utiliza una subconsulta para calcular el total de comentarios por
usuario y luego filtra aquellos usuarios que hayan realizado m�s de 100 comentarios en
total. Presenta los resultados en una tabla mostrando el DisplayName de los usuarios  */

SELECT Users.DisplayName
FROM Users
WHERE Users.UserId IN (
    SELECT Comments.UserId
    FROM Comments
    GROUP BY Comments.UserId
    HAVING COUNT(Comments.CommentId) > 100

--Consulta 5   
/* Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vac�as por "Desconocido". Utiliza una consulta de actualizaci�n para cambiar las ubicaciones vac�as. Muestra un mensaje indicando que la actualizaci�n se realiz� correctamente.--  */
BEGIN TRANSACTION;
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';
IF @@ROWCOUNT > 0
BEGIN
    PRINT 'La actualizaci�n se realiz� correctamente';
END
ELSE
BEGIN
    PRINT 'No se realizaron cambios';
END

COMMIT TRANSACTION;

--- consulta 6 ---
/* Elimina todos los comentarios realizados por usuarios con menos de 100 de reputaci�n.
Utiliza una consulta de eliminaci�n para eliminar todos los comentarios realizados y
muestra un mensaje indicando cu�ntos comentarios fueron eliminados  */

-- Inicia la transacci�n
BEGIN TRANSACTION;

-- Elimina los comentarios realizados por usuarios con menos de 100 de reputaci�n
DELETE FROM Comments
WHERE UserId IN (
    SELECT UserId
    FROM Users
    WHERE Reputation < 100
);

-- Muestra el n�mero de comentarios eliminados
DECLARE @Count INT;
SET @Count = @@ROWCOUNT;

IF @Count > 0
BEGIN
    PRINT CAST(@Count AS VARCHAR) + ' comentarios fueron eliminados';
END
ELSE
BEGIN
    PRINT 'No se eliminaron comentarios';
END

-- Confirma la transacci�n
COMMIT TRANSACTION;

---consulta 7---
/* Para cada usuario, muestra el n�mero total de publicaciones (Posts), comentarios
(Comments) y medallas (Badges) que han realizado. Utiliza uniones (JOIN) para combinar
la informaci�n de las tablas Posts, Comments y Badges por usuario. Presenta los
resultados en una tabla mostrando el DisplayName del usuario junto con el total de
publicaciones, comentarios y medallas   */

WITH UserPosts AS (
    SELECT OwnerUserId, COUNT(DISTINCT Id) AS TotalPosts
    FROM Posts
    GROUP BY OwnerUserId
),
UserComments AS (
    SELECT UserId, COUNT(DISTINCT Id) AS TotalComments
    FROM Comments
    GROUP BY UserId
),
UserBadges AS (
    SELECT UserId, COUNT(DISTINCT Id) AS TotalBadges
    FROM Badges
    GROUP BY UserId
)
SELECT TOP 100
    Users.DisplayName, 
    ISNULL(UserPosts.TotalPosts, 0) AS TotalPosts,
    ISNULL(UserComments.TotalComments, 0) AS TotalComments,
    ISNULL(UserBadges.TotalBadges, 0) AS TotalBadges
FROM 
    Users
LEFT JOIN 
    UserPosts ON UserPosts.OwnerUserId = Users.Id
LEFT JOIN 
    UserComments ON UserComments.UserId = Users.Id
LEFT JOIN 
    UserBadges ON UserBadges.UserId = Users.Id
ORDER BY 
    Users.DisplayName;

---consulta 8 ----
/*Muestra las 10 publicaciones m�s populares basadas en la puntuaci�n (Score) de la
tabla Posts. Ordena las publicaciones por puntuaci�n de forma descendente y
selecciona solo las 10 primeras. Presenta los resultados en una tabla mostrando el Title
de la publicaci�n y su puntuaci�n    */

SELECT TOP(5) Text, CreationDate

SELECT TOP (10) Title, Score
FROM Posts
ORDER BY Score DESC

---consulta 9---
/*Muestra los 5 comentarios m�s recientes de la tabla Comments. Ordena los comentarios
por fecha de creaci�n de forma descendente y selecciona solo los 5 primeros. Presenta
los resultados en una tabla mostrando el Text del comentario y la fecha de creaci�n    */
SELECT TOP(5) Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC
