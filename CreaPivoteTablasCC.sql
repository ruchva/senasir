USE [SENARITD]
GO
/****** Object:  StoredProcedure [dbo].[CreaPivoteTablasCC]    Script Date: 13/08/2015 11:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreaPivoteTablasCC]
AS
BEGIN
	--**CERTIF_PMM_PU**--			
	DROP TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU
	SELECT * INTO SENARITD.dbo.Piv_CERTIF_PMM_PU       
	FROM CC.dbo.CERTIF_PMM_PU
	
	--SELECT * FROM SENARITD.dbo.Piv_CERTIF_PMM_PU
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_CERTIF_PMM_PU ADD EstadoM INT
	
		--NUP
		--1° grupo ci, matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_CERTIF_PMM_PU a ON a.Matricula = p.Matricula 
		  AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento  
		WHERE dbo.eliminaespacios(p.PrimerApellido) = dbo.eliminaespacios(a.Paterno) 
		  AND dbo.eliminaespacios(p.SegundoApellido) = dbo.eliminaespacios(a.Materno)
		
		--2° grupo ci y nombres comprobando
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_CERTIF_PMM_PU a 
		ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
		WHERE a.NUP IS NULL
		  AND p.NUP NOT IN ('28929','30732','46272','83403','85457','100505','206533')--no son las mismas personas
		
		--3° grupo matricula y nombres comprobando
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_CERTIF_PMM_PU a ON a.Matricula = p.Matricula  
		WHERE a.NUP IS NULL 
		  AND p.NUP NOT IN ('88878','88945','89124','90281','90817','93848','95306','140508','140510','140512','140513','140514','140515','140516')

		
		--ID_TRAMITE--CertificadoPMMPU 
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--CertificadoPMMPU 
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--CertificadoPMMPU 
		UPDATE a SET a.IdBeneficio = CASE WHEN a.Clase_Pago = 'PU'  THEN 21
										  WHEN a.Clase_Pago = 'PMM' THEN 19
									 END
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a
	
		--ESTADO--CertificadoPMMPU 
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_CERTIF_PMM_PU a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.Estado = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106
			
	
	--**DOCUMENTO_COMPARATIVO**--
	DROP TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO
	SELECT * INTO SENARITD.dbo.Piv_DOC_COMPARATIVO
	FROM CC.dbo.DOC_COMPARATIVO dc
	
	--SELECT * FROM SENARITD.dbo.Piv_DOC_COMPARATIVO
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD NUP BIGINT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdTramite INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdGrupoBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD IdBeneficio INT
	ALTER TABLE SENARITD.dbo.Piv_DOC_COMPARATIVO ADD EstadoM INT
		
		--NUP
		--1° grupo ci, matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_DOC_COMPARATIVO a ON p.Matricula = a.MATRICULA
		 AND dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
		WHERE p.PrimerApellido = a.PATERNO 
		  AND p.SegundoApellido = a.MATERNO

        --2° grupo ci y nombres
        UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_DOC_COMPARATIVO a ON dbo.fn_CharLTrim('0',dbo.eliminaespacios(dbo.eliminaLetras(dbo.eliminapuntos(a.CI)))) = p.NumeroDocumento
		WHERE a.NUP IS NULL
		  AND p.NUP NOT IN ('85457','100505','85457','100505','85457','100505','48573','82473','49674','83403','13513','73301','86071','46272','28929'
		,'206533','117439','91006','24346','115779','158430','131984','89593','194959')

		--3° grupo matricula y nombres
		UPDATE a SET NUP = p.NUP
		FROM Persona.Persona p 
		JOIN dbo.Piv_DOC_COMPARATIVO a ON p.Matricula = a.MATRICULA
		WHERE a.NUP IS NULL
		  AND p.NUP NOT IN ('16162','88803','88945','89124','89593','89702','90057','90281','90686','90702','90751','90797','90817','91518','91545','91567','91900','92875','93370'
		,'93698','93848','94947','95306','95957','96193','96526','96599','96687','97272','97396','140508','140510','140512','140513','140514','140515','140516')
		
		--ID_TRAMITE--DocumentoComparativo 		
		UPDATE a SET a.IdTramite = tp.IdTramite
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID_GRUPO_BENEFICIO--DocumentoComparativo
		UPDATE a SET a.IdGrupoBeneficio = tp.IdGrupoBeneficio
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Tramite.TramitePersona tp 
		ON a.NUP = tp.NUP	

		--ID BENEFICIO--DocumentoComparativo
		UPDATE a SET a.IdBeneficio = CASE WHEN a.SELEC = 'PU'  THEN 21
										  WHEN a.SELEC = 'PMM' THEN 19
										  WHEN a.SELEC = 'CC' AND a.TIPO_CC = 'M' THEN 16
										  WHEN a.SELEC = 'CC' AND a.TIPO_CC = 'G' THEN 17
									 END
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a		
		
		--ESTADO--DOCUMENTO_COMPARATIVO 		
		UPDATE a SET a.EstadoM = dc.IdDetalleClasificador
		FROM SENARITD.dbo.Piv_DOC_COMPARATIVO a JOIN SENARITD.Clasificador.DetalleClasificador dc
		ON a.ESTADO = dc.CodigoDetalleClasificador
		WHERE dc.IdTipoClasificador = 106	
		
END 