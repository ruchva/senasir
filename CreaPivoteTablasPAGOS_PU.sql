ALTER PROCEDURE [dbo].[CreaPivoteTablasPAGOS_PU]
AS
BEGIN
	--PRE BENEFICIARIOS
	DROP TABLE dbo.Piv_PreBeneficiarios
	SELECT * INTO dbo.Piv_PreBeneficiarios
	FROM PAGOS_P.dbo.Pre_Beneficiarios a
	
	--SELECT * FROM dbo.Piv_PreBeneficiarios
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD NUP BIGINT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD IdTramite INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD IdGrupoBeneficio INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD Parentesco INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD Estado INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD ClaseBeneficio INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD RedDH INT
	ALTER TABLE dbo.Piv_PreBeneficiarios ADD NUPDH BIGINT
		
		--NUP--PreBeneficiarios
		--1° grupo ci, matricula
		UPDATE a SET NUP = p2.NUP
		FROM dbo.Piv_PreBeneficiarios a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
		
		--2° grupo ci
		UPDATE a SET NUP = p2.NUP
		FROM dbo.Piv_PreBeneficiarios a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
		WHERE a.NUP IS NULL
		
		--3° grupo matricula
		UPDATE a SET NUP = p2.NUP
		FROM dbo.Piv_PreBeneficiarios a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
		WHERE a.NUP IS NULL AND p2.NumeroDocumento <> ''
		
		--ID_TRAMITE--PreBeneficiarios
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM dbo.Piv_PreBeneficiarios a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PreBeneficiarios
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM dbo.Piv_PreBeneficiarios a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--PARENTESCO--PreBeneficiarios
		UPDATE a SET Parentesco = CASE WHEN a.PARENTESCO = 'H' THEN 4 ELSE 3 END
		FROM dbo.Piv_PreBeneficiarios a

		--ESTADO--PreBeneficiarios
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM dbo.Piv_PreBeneficiarios a JOIN Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109

		--CALSE BENEFICIO--PreBeneficiarios
		UPDATE a SET a.ClaseBeneficio = dc.IdDetalleClasificador
		FROM dbo.Piv_PreBeneficiarios a JOIN Clasificador.DetalleClasificador dc
		ON a.CLASE_BENEFICIO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 110

		--RED_DH --PreBeneficiarios
		UPDATE a SET a.RedDH = dc.IdDetalleClasificador
		FROM dbo.Piv_PreBeneficiarios a JOIN Clasificador.DetalleClasificador dc
		ON a.RED_DH = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 111
		
		--NUPDH --PreBeneficiarios /***TODO:derechohabientes
		UPDATE a SET NUPDH = p2.NUP
		FROM dbo.Piv_PreBeneficiarios a
		JOIN CRENTA.dbo.PERSONA p ON a.DH_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON p2.Matricula = a.DH_MATRICULA
		where a.NUP is not null and a.NUPDH is null and p2.NUP not in (11833,37263,70285,190132,215491,252674,283936)--piloto 1*/		

	--PRE TITULARES 
	DROP TABLE dbo.Piv_PreTitulares
	SELECT * INTO dbo.Piv_PreTitulares
	FROM PAGOS_P.dbo.Pre_Titulares a
	
	--SELECT * FROM dbo.Piv_PreTitulares
	ALTER TABLE dbo.Piv_PreTitulares ADD NUP BIGINT
	ALTER TABLE dbo.Piv_PreTitulares ADD IdTramite INT
	ALTER TABLE dbo.Piv_PreTitulares ADD IdGrupoBeneficio INT
	ALTER TABLE dbo.Piv_PreTitulares ADD IdBeneficio INT
	ALTER TABLE dbo.Piv_PreTitulares ADD Estado INT
		
		--NUP
		--1° ci, matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_PreTitulares a ON p.Matricula = a.MATRICULA
			AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
		WHERE p.PrimerApellido = a.T_PATERNO 
			AND p.SegundoApellido = a.T_MATERNO
		
		--2° ci, nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_PreTitulares a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
		WHERE a.NUP IS NULL AND p.NUP NOT IN ('85457','100505')
				
		--3° matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_PreTitulares a ON p.Matricula = a.MATRICULA
		WHERE a.NUP IS NULL AND p.NUP NOT IN ('88945','93848','140515','140516')
		
		--ID_TRAMITE--PreTitulares
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM dbo.Piv_PreTitulares a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM dbo.Piv_PreTitulares a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--PRE TITULARES 		
		UPDATE a SET a.IdBeneficio = CASE WHEN a.CLASE_PAGO = '1' THEN 19
										  WHEN a.CLASE_PAGO = '2' THEN 21
										  WHEN a.CLASE_PAGO = '3' THEN 20
										  WHEN a.CLASE_PAGO = '4' THEN 22
									 END 
		FROM  dbo.Piv_PreTitulares a
		
		--ESTADO--PRE TITULARES		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM dbo.Piv_PreTitulares a JOIN Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--TITULAR_PU 
	DROP TABLE dbo.Piv_TitularPU
	SELECT * INTO dbo.Piv_TitularPU
	FROM PAGOS_P.dbo.Titular_PU a
	
	--SELECT * FROM dbo.Piv_TitularPU
	ALTER TABLE dbo.Piv_TitularPU ADD NUP BIGINT
	ALTER TABLE dbo.Piv_TitularPU ADD IdTramite INT
	ALTER TABLE dbo.Piv_TitularPU ADD IdGrupoBeneficio INT
	ALTER TABLE dbo.Piv_TitularPU ADD Estado INT
		
		--NUP--TitularPU
		--1° ci, matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA
		 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
		WHERE p.PrimerApellido = a.T_PATERNO 
		  AND p.SegundoApellido = a.T_MATERNO
		
		--2° ci y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_TitularPU a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.NUM_IDENTIF)))) = p.NumeroDocumento
		WHERE a.NUP IS NULL AND p.NumeroDocumento <> '' AND p.NUP NOT IN (68170,6786,354,90524,90533,163693,90817,86259,63580,15748,50359
		,208281,67544,92063,53002,138734,51387,97904,78401,92241,21513,88535,88535,92364,207764,25626,199002,92454,1614750
		,81236,6165672878,107253,115396,125645,150436,204121,93017,24816,77668,210348,93273,156653,56708,93699,194342,186485
		,88839,58377,88885,69002,69002,88971,88971,88984,59072,10005,17840,94715,89232,89232,9110,79919,210365,210554,208439
		,89363,81933,20269,95306,89517,95623,151308,83423,209116,89824,89831,89938,90056,48843)
		
		--3° matriculas y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
		WHERE a.NUP IS NULL
		  AND p.PrimerApellido = a.T_PATERNO 
		  AND p.SegundoApellido = a.T_MATERNO
		
		--4° matriculas y nombres berificados
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_TitularPU a ON p.Matricula = a.T_MATRICULA 
		WHERE a.NUP IS NULL AND p.NUP NOT IN (90524,140508,140510,140512,140513,140514,140515,140516)
				
		--ID_TRAMITE--TITULAR_PU		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM dbo.Piv_TitularPU a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--TITULAR_PU		
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM dbo.Piv_TitularPU a JOIN Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ESTADO--TITULAR_PU		
		UPDATE a SET a.Estado = dc.IdDetalleClasificador
		FROM dbo.Piv_TitularPU a JOIN Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109	
		
	--CHEQUE_PU
	DROP TABLE dbo.Piv_ChequePU
	SELECT * INTO dbo.Piv_ChequePU
	FROM PAGOS_P.dbo.chePU cp
	
	--SELECT * FROM dbo.Piv_ChequePU
	ALTER TABLE dbo.Piv_ChequePU ADD NUPTitular BIGINT
	ALTER TABLE dbo.Piv_ChequePU ADD NUPDH BIGINT
	ALTER TABLE dbo.Piv_ChequePU ADD EstadoM INT
	ALTER TABLE dbo.Piv_ChequePU ADD IdBanco INT
	ALTER TABLE dbo.Piv_ChequePU ADD Conciliado INT
		
		--NUP ChequePU
		--1° ci, matricula y nombres
		UPDATE a SET NUPTitular = p2.NUP
		FROM dbo.Piv_ChequePU a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
		 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
		
		--2° ci, nombres
		UPDATE a SET NUPTitular = p2.NUP
		FROM dbo.Piv_ChequePU a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(p.CI)))) = p2.NumeroDocumento
		WHERE a.NUPTitular IS NULL
		
		--3° matricula y nombres
		UPDATE a SET NUPTitular = p2.NUP
		FROM dbo.Piv_ChequePU a
		JOIN CRENTA.dbo.PERSONA p ON a.T_MATRICULA = p.Matricula
		JOIN Persona.Persona p2 ON p2.Matricula = a.T_MATRICULA
		WHERE a.NUPTitular IS NULL AND p2.NumeroDocumento <> '' AND p2.NUP NOT IN (140508,140510,140512,140513,140514,140515,140516)
		
		--NUP DH--ChequePU /**completar DH**/		
		UPDATE a SET NUPDH = p.NUP
		FROM dbo.Piv_ChequePU a JOIN Persona.Persona p 
		ON a.DH_MATRICULA = p.Matricula
		
		--ESTADO--ChequePU				
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM dbo.Piv_ChequePU a JOIN Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 109 

		--ID_BANCO--ChequePU	
		UPDATE a SET IdBanco = CASE WHEN a.BANCO = 3 THEN 802 
									WHEN a.BANCO = 4 THEN 806  
									WHEN a.BANCO = 5 THEN 811
							   END
		FROM dbo.Piv_ChequePU a
		
		--CONCILIADO--ChequePU
				
		
END