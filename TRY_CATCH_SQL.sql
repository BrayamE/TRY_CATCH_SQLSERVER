use Tienda3

select * from Personas;

ALTER TABLE Personas
ADD NumeroDOC NVARCHAR(10);

CREATE PROCEDURE CrearPersona(
	@Nombre NVARCHAR(100),
	@ApellidoPaterno NVARCHAR(100),
	@ApellidoMaterno NVARCHAR(100),
	@FechaNacimiento DATE,
	@Email NVARCHAR(255),
	@NumeroDOC NVARCHAR(10)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		--VALIDAR FECHA DE NACIMIENTO
		IF @FechaNacimiento >= GETDATE()
		BEGIN
			THROW 51001, 'La fecha de nacimiento debe ser anterior a la fecha actual', 17;
		END;
		--VALIDAR NUMERO DE CARACTERES DE NumeroDOC
		IF LEN(@NumeroDOC) <> 8
		BEGIN
			THROW 51002, 'El campo NumeroDOC debe tener exactamente ocho caracteres', 18;
		END;

		--VALIDAR @ EN EL CORREO
		IF @Email NOT LIKE '%@%'
        BEGIN
            THROW 51003, 'El correo no es válido', 19;
        END;
		--VALIDACION DEL DOMINIO @gmail.com
		IF RIGHT(@Email, CHARINDEX('@', REVERSE(@Email)) - 1) <> 'gmail.com'
        BEGIN
            THROW 51003, 'El dominio del correo no es válido', 17;
        END;
		--VALIDACION DE CARACTERES (MINIMO 3 CARACTERES)
		IF LEN(@Nombre) < 3 OR LEN(@ApellidoPaterno) < 3 OR LEN(@ApellidoMaterno) < 3
        BEGIN
            THROW 51002, 'El Nombre, Apellido Paterno y Apellido Materno deben tener al menos 3 caracteres', 19;
        END;
		--VALIDAR QUE EN EL CORREO CONTENGA EL NOMBRE Y APELLIDO
		 IF NOT @Email LIKE @Nombre + '.' + @ApellidoPaterno + '%@%'
        BEGIN
            THROW 51002,'El formato del correo electrónico no es válido',1;
        END;

		COMMIT;
	END TRY
	BEGIN CATCH
		
		ROLLBACK;
	END CATCH
END;


DECLARE @Nombre NVARCHAR(100) = 'brayam'
DECLARE @ApellidoPaterno NVARCHAR(100) = 'quispe'
DECLARE @ApellidoMaterno NVARCHAR(100) = 'apaza'
DECLARE @FechaNacimiento DATE = '2023-10-10'
DECLARE @Email NVARCHAR(255) = 'brayam.quispe@gmail.com'
DECLARE @NumeroDOC NVARCHAR(10) = '12345678'

EXEC CrearPersona
	@Nombre = @Nombre,
	@ApellidoPaterno = @ApellidoPaterno,
	@ApellidoMaterno = @ApellidoMaterno,
	@FechaNacimiento = @FechaNacimiento,
	@Email = @Email,
	@NumeroDOC = @NumeroDOC;

---BRAYAM EDWIN QUISPE APAZA
	
