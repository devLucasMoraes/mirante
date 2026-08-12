USE wingraphex;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

-- ============================================================
-- SCHEMA DO SISTEMA WINGRAPHEX (ERP) - somente estrutura
-- Fonte: MySQL 5.7.26 em 192.168.1.16:3307
-- Extraido em: 11/08/2026
-- Conteudo: 557 tabelas BASE TABLE (CREATE TABLE) sem dados
-- Excluido/nao extraido:
--   1 view `consultaatualizaprecomedio` (sem privilegio SHOW VIEW)
--   5 rotinas (`ObterValorCTEItem`, `__fncObterNumeroNF`,
--     `__fncObterProximaChave`, `__prcAtualizarSaldoFisico`,
--     `__prcInserirRegistroEstoqueItemSaldo`) - corpo requer
--     privilegio SHOW CREATE FUNCTION (user _consulta nao tem)
--   Obs: definir essas rotinas manualmente quando tiver acesso
--   2 tabelas MyISAM possivelmente nao dumpadas se sem privilegio
-- Engine: InnoDB (552) + MyISAM (5) ; charset base latin1
-- Metodo: mysqldump --no-data --routines --skip-lock-tables
-- ============================================================
-- Modo de recriacao: mysql destino < schema-wingraphex.sql
-- ============================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `_ajuda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_ajuda` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TELA` varchar(50) NOT NULL DEFAULT '',
  `CONTEUDO` longtext NOT NULL,
  `OBSERVACAO` longtext NOT NULL,
  `ATALHO` longtext NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_arquivoversionamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_arquivoversionamento` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `nomearquivo` varchar(100) DEFAULT NULL,
  `versaoarquivo` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_atualizacaoautomatica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_atualizacaoautomatica` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `VERSAO` varchar(30) NOT NULL,
  `DATAHORAREGISTRO` datetime NOT NULL,
  `DATAHORAAGENDAMENTO` datetime DEFAULT NULL,
  `STATUSATUALIZACAO` varchar(30) NOT NULL,
  `OBSERVACAO` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_atualizacaoautomaticausuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_atualizacaoautomaticausuario` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_ATUALIZACAOAUTOMATICA` int(11) NOT NULL,
  `ID_SEGUSUARIO` int(11) NOT NULL,
  `STATUSATUALIZACAO` int(11) NOT NULL,
  `LIDO` char(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_bcons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_bcons` (
  `CODIGO` int(10) NOT NULL COMMENT 'Código',
  `ID_CONSPAI` int(11) DEFAULT '0',
  `TIPO` varchar(30) DEFAULT NULL,
  `DESCRICAO` varchar(50) DEFAULT NULL COMMENT 'Nome da consulta',
  `MODULO` varchar(50) DEFAULT NULL COMMENT 'Número dos modulos',
  `CMDSQL` text COMMENT 'Comando SQL',
  `PARAMETROS` text COMMENT 'Parametros',
  `LARGURAS` varchar(50) DEFAULT NULL COMMENT 'Larguras',
  `NOMETABELA` varchar(50) DEFAULT NULL,
  `TIPOCONSULTA` varchar(20) NOT NULL,
  `ATIVA` char(1) NOT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_brelitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_brelitem` (
  `BRP_PASTAID` int(11) NOT NULL DEFAULT '0',
  `BRI_ITEMID` int(11) NOT NULL DEFAULT '0',
  `BRI_DESCRICAO` varchar(60) NOT NULL DEFAULT '',
  `BRI_TAMANHO` int(11) NOT NULL DEFAULT '0',
  `BRI_TIPOITEM` int(11) NOT NULL DEFAULT '0',
  `BRI_MODIFICADO` datetime DEFAULT NULL,
  `BRI_DELETADO` datetime DEFAULT NULL,
  `BRI_TEMPLATE` longblob NOT NULL,
  `BRI_ATIVO` char(1) NOT NULL DEFAULT '',
  `BRI_TBLEMAILDEST` varchar(50) DEFAULT NULL,
  `BRI_MODULOSRELACIONADOS` varchar(60) DEFAULT '',
  PRIMARY KEY (`BRP_PASTAID`,`BRI_ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_brelitemlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_brelitemlog` (
  `BRI_ITEMID` int(11) NOT NULL DEFAULT '0',
  `USUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAHORAEXECUCAO` datetime DEFAULT NULL,
  `CONTADOR` int(11) DEFAULT '0',
  PRIMARY KEY (`BRI_ITEMID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_brellocal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_brellocal` (
  `BRP_ID` int(11) NOT NULL,
  `BRP_LOCAL` varchar(100) NOT NULL,
  `BRP_PASTAID` int(11) NOT NULL,
  `BRI_ITEMID` int(11) NOT NULL,
  PRIMARY KEY (`BRP_ID`),
  KEY `fkBRelLocal` (`BRI_ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_brelpasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_brelpasta` (
  `BRP_PASTAID` int(11) NOT NULL DEFAULT '0',
  `BRP_DESCRICAO` varchar(60) NOT NULL DEFAULT '',
  `BRP_PASTAPAIID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`BRP_PASTAID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_bserver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_bserver` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `DATAULTIMAMANUTENCAO` date DEFAULT NULL,
  `ERROREESTRUTURAR` char(1) DEFAULT NULL,
  `DATAATUALIZACAO` datetime DEFAULT NULL,
  `NUMEROVERSAODESEJADA` varchar(20) DEFAULT NULL,
  `MSGERROREESTRUTURACAO` varchar(200) DEFAULT NULL,
  `NOTIFICACAOATUAL` longtext,
  `DATAULTIMATENTLIC` datetime DEFAULT NULL,
  `ULTIMOCODRET` varchar(5) DEFAULT NULL,
  `ULTMOMSGRET` varchar(500) DEFAULT NULL,
  `CODIGOBREMEN` char(4) DEFAULT NULL,
  `LICENCIADOPARA` varchar(100) DEFAULT NULL,
  `STATUSLICENCIAMENTO` varchar(50) DEFAULT NULL,
  `EUS` text,
  `TRANSICAOMACHINEID` varchar(100) DEFAULT NULL,
  `DATAULTIMAEXECBSERVER` varchar(100) DEFAULT NULL,
  `SOLICITOUPEDLIBERACAOTOLERANCIA` char(1) DEFAULT NULL,
  `VERSAOTABAUX` varchar(30) DEFAULT NULL,
  `VERSAOARQAUX` varchar(30) DEFAULT NULL,
  `STATUSREPLICACAO` varchar(30) DEFAULT NULL,
  `AGENDAMENTORECONFREPLICACAO` datetime DEFAULT NULL,
  `DESCRICAOSTATUSREPLICACAO` varchar(200) DEFAULT NULL,
  `URLNETREPLICACAO` varchar(100) DEFAULT NULL,
  `PORTAREPLICACAO` int(11) DEFAULT NULL,
  `TOKEN` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_bserver2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_bserver2` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `6m0R9VJG7nPD96cxXwY9O+` varchar(100) DEFAULT NULL,
  `NUadla788dAN26w6YGnVRE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_bserversvc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_bserversvc` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NOMESERVICO` varchar(30) NOT NULL,
  `STATUS` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_cobboleto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_cobboleto` (
  `ID_USUARIO` int(11) NOT NULL,
  `SEQUENCIAL` int(11) NOT NULL,
  `CODIGOAGENCIABENEFICIARIO` varchar(30) NOT NULL,
  `CODIGOBENEFICIARIO` varchar(30) NOT NULL,
  `NOSSONUMERO` varchar(100) NOT NULL,
  `DIGITONOSSONUMERO` varchar(100) NOT NULL,
  `CARTEIRA` varchar(100) NOT NULL,
  `ESPECIEDOCUMENTO` varchar(30) NOT NULL,
  `CODIGOBANCOBENEFICIARIO` varchar(30) NOT NULL,
  `INSTRUCOES` longtext NOT NULL,
  `DATAVENCIMENTO` date NOT NULL,
  `TIPOINSCRICAOBENEFICIARIO` varchar(30) NOT NULL,
  `NUMEROCPFCNPJBENEFICIARIO` varchar(30) NOT NULL,
  `NOMEBENEFICIARIO` varchar(100) NOT NULL,
  `RUABENEFICIARIO` varchar(100) NOT NULL,
  `NUMEROBENEFICIARIO` varchar(6) NOT NULL,
  `CIDADEBENEFICIARIO` varchar(50) NOT NULL,
  `ESTADOBENEFICIARIO` varchar(2) NOT NULL,
  `CEPBENEFICIARIO` varchar(8) NOT NULL,
  `TIPOINSCRICAOPAGADOR` varchar(30) NOT NULL,
  `NUMEROCPFCNPJPAGADOR` varchar(30) NOT NULL,
  `RUAPAGADOR` varchar(100) NOT NULL,
  `NUMEROPAGADOR` varchar(6) NOT NULL,
  `COMPLEMENTOPAGADOR` varchar(30) NOT NULL,
  `BAIRROPAGADOR` varchar(30) NOT NULL,
  `CIDADEPAGADOR` varchar(50) NOT NULL,
  `ESTADOPAGADOR` varchar(2) NOT NULL,
  `CEPPAGADOR` varchar(8) NOT NULL,
  `DATADOCUMENTO` date NOT NULL,
  `NUMERODOCUMENTO` varchar(100) NOT NULL,
  `VALORDOCUMENTO` double(18,8) NOT NULL,
  `CODIGOPAGADOR` varchar(20) NOT NULL,
  `NOMEPAGADOR` varchar(100) NOT NULL,
  `PARCELAINICIAL` int(11) NOT NULL,
  `PARCELAFINAL` int(11) NOT NULL,
  `CODIGOBANCOBOLETO` varchar(5) NOT NULL,
  `NOMEBANCOBOLETO` varchar(100) NOT NULL,
  `LOCALPAGAMENTO` varchar(100) NOT NULL,
  `ESPECIEMODA` varchar(5) NOT NULL,
  `QUANTIDADEMOEDA` varchar(5) NOT NULL,
  `VALORMOEDA` double(18,8) NOT NULL,
  `CODIGOBARRA` varchar(100) NOT NULL,
  `LINHADIGITAVEL` varchar(100) NOT NULL,
  `DATAPROCESSAMENTO` datetime NOT NULL,
  `AGENCIACODIGOBENEFICIARIOBOLETO` varchar(100) NOT NULL,
  `NOSSONUMEROBOLETO` varchar(100) NOT NULL,
  `CARTEIRABOLETO` varchar(30) NOT NULL,
  `USOBANCOBOLETO` varchar(50) NOT NULL,
  `ACEITE` char(1) NOT NULL,
  PRIMARY KEY (`ID_USUARIO`,`SEQUENCIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_cobcampo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_cobcampo` (
  `LAYOUT_ID` int(11) NOT NULL,
  `REG_ID` int(11) NOT NULL,
  `CAMPO_ID` int(11) NOT NULL,
  `SEQUENCIAL` int(10) NOT NULL,
  `DESCRICAO` varchar(50) NOT NULL,
  `CAMPO` varchar(50) NOT NULL,
  `TAMANHO` int(11) NOT NULL,
  `DECIMAIS` int(11) NOT NULL,
  `TIPO` varchar(15) NOT NULL,
  `SCRIPT` longtext,
  `MASCARA` varchar(15) DEFAULT NULL,
  `POSICAOINICIAL` int(11) NOT NULL,
  `POSICAOFINAL` int(11) NOT NULL,
  PRIMARY KEY (`CAMPO_ID`,`LAYOUT_ID`,`REG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_coblayout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_coblayout` (
  `LAYOUT_ID` int(11) NOT NULL,
  `DESCRICAO` varchar(50) NOT NULL,
  `TIPOCNAB` varchar(30) NOT NULL,
  `TIPOLAYOUT` varchar(30) NOT NULL,
  `CODIGOBANCO` varchar(30) NOT NULL,
  `SCRIPTMODULO10` longtext,
  `SCRIPTMODULO11` longtext,
  `SCRIPTCAMPOLIVRE` longtext,
  `SCRIPTCALCDIGITONOSSONUM` longtext,
  `SCRIPTFORMATARBOLETO` longtext,
  `SCRIPTMONTARNOSSONUM` longtext,
  `SCRIPTDESMONTARNOSSONUM` longtext,
  `MASCARANOMEARQUIVO` longtext,
  PRIMARY KEY (`LAYOUT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_cobparametroscarteira`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_cobparametroscarteira` (
  `EMP_ID` int(11) NOT NULL,
  `IDPARAMETROCARTEIRA` int(11) NOT NULL,
  `CODIGOBANCO` varchar(30) NOT NULL,
  `NOMEPARAMETRO` varchar(50) NOT NULL,
  `DESCRICAOPARAMETRO` varchar(50) NOT NULL,
  `VALORESPARAMETROS` longtext,
  `TIPO` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`IDPARAMETROCARTEIRA`,`CODIGOBANCO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_cobregistro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_cobregistro` (
  `LAYOUT_ID` int(11) NOT NULL,
  `REG_ID` int(11) NOT NULL,
  `SEQUENCIAL` int(11) NOT NULL,
  `DESCRICAO` varchar(50) NOT NULL,
  `TIPO` varchar(20) NOT NULL,
  `IDENTIFICADOR` char(1) DEFAULT NULL,
  PRIMARY KEY (`REG_ID`,`LAYOUT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_configsistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_configsistema` (
  `L6iaBeSwLoOkiQTE9CFhP+` int(11) NOT NULL,
  `xG74Daq4pG4ZV4M-kezzJU` varchar(100) DEFAULT '',
  `odpNA-cumooUFtAwOTEVGk` varchar(100) NOT NULL DEFAULT '',
  `n4yUlQZs8oYPPAjvEkkbvk` varchar(100) NOT NULL DEFAULT '',
  `4lFrTtyvPysVW23uWRsKmE` varchar(100) NOT NULL DEFAULT '',
  `ZSaFVjuKgs-8vMN2cr2cyE` varchar(100) NOT NULL DEFAULT '',
  `AgiLVjOeuqygP68NNhwqKk` varchar(100) NOT NULL,
  `-m-I4rtmXN8okZuPVypEAk` varchar(100) NOT NULL,
  `BFoeK8UA6V3WKJRvZEe2Z+` varchar(100) NOT NULL,
  `Vh3DMtJYOkWg0XyySJa0C+` varchar(100) DEFAULT NULL,
  `NJIqbMIw4-S8e28yQRIWlE` varchar(100) NOT NULL,
  `t7RHWNd-fvf6Rak3aUbnek` varchar(100) NOT NULL,
  `dUyebibpa3xrH-TSXTGdGE` varchar(100) NOT NULL,
  `B-Nznwv90cAWgsV3GIIdg+` varchar(500) NOT NULL,
  PRIMARY KEY (`L6iaBeSwLoOkiQTE9CFhP+`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_configusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_configusuario` (
  `USU_ID` int(11) NOT NULL,
  `TELACHEIA` char(1) DEFAULT NULL,
  `EXIBIRMENUREDUZIDO` char(1) DEFAULT NULL,
  `EXIBIRTREEVIEW` char(1) DEFAULT NULL,
  `TAMANHOTREEVIEW` int(11) DEFAULT NULL,
  `MOSTRARNOTIFICACOES` char(1) DEFAULT NULL,
  `EXIBIRALERTANOTIFICACAO` char(1) DEFAULT NULL,
  `AUTO_OCULTAR` char(1) DEFAULT NULL,
  PRIMARY KEY (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_contagemconsultascnpj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_contagemconsultascnpj` (
  `DIA` date NOT NULL DEFAULT '0000-00-00',
  `CONTAGEMCONSULTAS` int(11) DEFAULT NULL,
  PRIMARY KEY (`DIA`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_dicionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_dicionario` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tablename` varchar(50) DEFAULT NULL,
  `tabela` varchar(50) DEFAULT NULL,
  `fieldname` varchar(50) DEFAULT NULL,
  `campo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7322 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_exception`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_exception` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NOMEEXE` varchar(50) NOT NULL,
  `DATAGERACAO` datetime NOT NULL,
  `ORIGEMERRO` varchar(200) DEFAULT NULL,
  `NOMEUSUARIO` varchar(50) DEFAULT NULL,
  `MSGERRO` longtext NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=139587 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_exportacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_exportacao` (
  `ID_EXPORTACAO` int(11) NOT NULL AUTO_INCREMENT,
  `ID_INTEGRACAO` int(11) NOT NULL,
  `EMP_ID` int(11) NOT NULL,
  `VALORESCHAVE` varchar(50) NOT NULL,
  `DATAHORAGRAVACAO` datetime NOT NULL,
  `DATAHORAPROCESSAMENTO` datetime DEFAULT NULL,
  `CAMPOSCHAVES` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_EXPORTACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=30883 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_exportacaolog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_exportacaolog` (
  `ID_EXPORTACAOLOG` int(11) NOT NULL,
  `ID_PERFILINTEGRACAO` int(11) NOT NULL,
  `ID_EXPORTACAO` int(11) DEFAULT NULL,
  `DATAPROCESSAMENTO` datetime NOT NULL,
  `STATUSPROCESSAMENTO` varchar(30) NOT NULL,
  `MSGERRO` longtext,
  `CONTEUDOPOST` longtext,
  PRIMARY KEY (`ID_EXPORTACAOLOG`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_feed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_feed` (
  `ID_FEED` int(10) NOT NULL AUTO_INCREMENT,
  `NUMEROFEED` int(11) NOT NULL,
  `TITULO` varchar(100) DEFAULT NULL,
  `DESCRICAO` varchar(300) NOT NULL,
  `URL` varchar(200) NOT NULL,
  `DATAINICIOVIGENCIA` date NOT NULL,
  `DATAFIMVIGENCIA` date NOT NULL,
  `IMG` blob,
  `CONDICAO` varchar(500) DEFAULT NULL,
  `ATIVO` int(11) NOT NULL,
  PRIMARY KEY (`ID_FEED`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_historicoconsultajson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_historicoconsultajson` (
  `ID_CONSULTA` int(11) NOT NULL AUTO_INCREMENT,
  `TIPOCONSULTA` varchar(50) DEFAULT NULL,
  `CODIGO_IDENTIFICADOR` varchar(20) NOT NULL,
  `RAZAOSOCIAL` varchar(255) DEFAULT NULL,
  `NOMEFANTASIA` varchar(255) DEFAULT NULL,
  `DATACONSULTA` datetime DEFAULT NULL,
  `COD_USUARIO` int(11) DEFAULT NULL,
  `USUARIO` varchar(50) NOT NULL,
  `DATASTRING` longtext,
  PRIMARY KEY (`ID_CONSULTA`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=334 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_importacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_importacao` (
  `ID_IMPORTACAO` int(11) NOT NULL AUTO_INCREMENT,
  `ID_PERFIL` int(11) NOT NULL,
  `DATAHORAPROCESSAMENTO` datetime DEFAULT NULL,
  `CAMINHOARQUIVO` varchar(200) NOT NULL,
  `NOMEARQUIVO` varchar(200) NOT NULL,
  `ERRO` longtext,
  `PROCESSADO` char(1) NOT NULL,
  `CORPOJSON` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`ID_IMPORTACAO`),
  KEY `akPerfilIntegracao` (`ID_PERFIL`),
  KEY `akNOMEARQUIVO` (`NOMEARQUIVO`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_importacaologpedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_importacaologpedido` (
  `ID_IMPORTACAOLOG` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(11) NOT NULL,
  `DOC_ID` int(11) NOT NULL,
  `CLASSIFICACAO` int(11) NOT NULL,
  `NUMEROSERIE` varchar(30) NOT NULL,
  `NUMERONF` int(11) NOT NULL,
  `NUMERONFCONTROLE` varchar(15) NOT NULL,
  `ID_INTEGRACAO` int(11) NOT NULL,
  `TIPO` varchar(30) NOT NULL,
  `DATAHORAPROCESSAMENTO` datetime DEFAULT NULL,
  `ERRO` longtext,
  `STATUSPROCESSAMENTO` varchar(30) NOT NULL,
  PRIMARY KEY (`ID_IMPORTACAOLOG`),
  KEY `akDocumento` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `akStatus` (`STATUSPROCESSAMENTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_intref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_intref` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `INT_NOMETABELA` varchar(50) NOT NULL DEFAULT '',
  `INT_SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `INT_VALOR` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`INT_NOMETABELA`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_liberacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_liberacoes` (
  `numero` smallint(4) unsigned NOT NULL DEFAULT '0',
  `numeroliberacao` varchar(20) NOT NULL DEFAULT '0',
  `dataliberacao` date NOT NULL DEFAULT '0000-00-00',
  `dataatualizacao` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `problemareestruturar` char(1) NOT NULL DEFAULT '',
  `mensagemerro` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_logbserver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_logbserver` (
  `LGB_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `LGB_DESCLOG` longtext NOT NULL,
  `LGB_LIDO` char(1) NOT NULL DEFAULT '',
  `LGB_DATAHORA` datetime NOT NULL,
  `LGB_TIPO` varchar(20) NOT NULL,
  PRIMARY KEY (`LGB_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19518 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_logbserverexec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_logbserverexec` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATAULTIMAEXEC` datetime DEFAULT NULL,
  `DATAATUALWINDOWS` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_logmanutencaoex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_logmanutencaoex` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATAEMISSAO` datetime NOT NULL,
  `IDENTIFICACAO` varchar(10) NOT NULL,
  `OPCAO` varchar(200) NOT NULL,
  `FILTRO` varchar(200) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_logwingraph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_logwingraph` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DATA` datetime DEFAULT NULL,
  `USUARIO` varchar(30) DEFAULT NULL,
  `COMANDOSQL` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3035371 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_notificacoesdestinatario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_notificacoesdestinatario` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_NOTIFICACOESPERFIL` int(11) NOT NULL,
  `ID_GRUPOUSUARIO` int(11) DEFAULT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_NOTIFICACOESPERFIL_NOTIFICACOESDESTINATARIO` (`ID_NOTIFICACOESPERFIL`),
  CONSTRAINT `fk_NOTIFICACOESPERFIL_NOTIFICACOESDESTINATARIO` FOREIGN KEY (`ID_NOTIFICACOESPERFIL`) REFERENCES `_notificacoesperfil` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_notificacoesperfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_notificacoesperfil` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DESCRICAOPERFIL` varchar(100) NOT NULL,
  `TITULOPERFIL` varchar(100) NOT NULL,
  `FREQUENCIA` varchar(30) NOT NULL,
  `SQLNOTIFICACAO` longtext NOT NULL,
  `DESATIVADO` char(1) NOT NULL,
  `TIPO` varchar(30) NOT NULL,
  `VALORFREQUENCIA` varchar(50) DEFAULT NULL,
  `DATAULTIMAEXEC` datetime DEFAULT NULL,
  `CONFIGCOLUNAS` varchar(500) NOT NULL,
  `ORDEM` int(11) NOT NULL,
  `MODULOS` varchar(100) DEFAULT NULL,
  `CONTAEMAIL` int(11) DEFAULT NULL,
  `ASSUNTOEMAIL` varchar(200) DEFAULT NULL,
  `CORPOEMAIL` longtext,
  `EMAILDESTINO` varchar(100) DEFAULT NULL,
  `IDRTMPADRAO` int(11) DEFAULT NULL,
  `DETALHARRELATORIO` char(1) NOT NULL,
  `CAMPOSCHAVESRELATORIO` varchar(200) DEFAULT NULL,
  `SEQUENCIALNOMEARQUIVOPDF` int(11) NOT NULL,
  `TABELACHAVERELATORIO` varchar(50) DEFAULT NULL,
  `TIPOSISTEMA` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_notificacoesresultado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_notificacoesresultado` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_NOTIFICACOESPERFIL` int(11) NOT NULL,
  `EMP_ID` int(11) DEFAULT NULL,
  `DATAEXECUCAO` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_NOTIFICACOESPERFIL_NOTIFICACOESRESULTADO` (`ID_NOTIFICACOESPERFIL`),
  CONSTRAINT `fk_NOTIFICACOESPERFIL_NOTIFICACOESRESULTADO` FOREIGN KEY (`ID_NOTIFICACOESPERFIL`) REFERENCES `_notificacoesperfil` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14047 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_notificacoesresultadodestinatario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_notificacoesresultadodestinatario` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_NOTIFICACOESRESULTADO` int(11) NOT NULL,
  `ID_NOTIFICACOESDESTINATARIO` int(11) NOT NULL,
  `ID_GRUPOUSUARIO` int(11) DEFAULT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `LIDO` char(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_NOTIFICACOESRESULTADO` (`ID_NOTIFICACOESRESULTADO`),
  KEY `FK_NOTIFICACOESDESTINATARIO` (`ID_NOTIFICACOESDESTINATARIO`),
  CONSTRAINT `FK_NOTIFICACOESDESTINATARIO` FOREIGN KEY (`ID_NOTIFICACOESDESTINATARIO`) REFERENCES `_notificacoesdestinatario` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_NOTIFICACOESRESULTADO` FOREIGN KEY (`ID_NOTIFICACOESRESULTADO`) REFERENCES `_notificacoesresultado` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=66982 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_notificacoesresultadodetalhe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_notificacoesresultadodetalhe` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_NOTIFICACOESPERFIL` int(11) NOT NULL,
  `ID_NOTIFICACOESRESULTADO` int(11) NOT NULL,
  `RESULTADOSQL` longtext NOT NULL,
  `CONTAEMAIL` int(11) DEFAULT NULL,
  `ASSUNTOEMAIL` varchar(200) DEFAULT NULL,
  `CORPOEMAIL` longtext,
  `EMAILDESTINO` varchar(100) DEFAULT NULL,
  `ENVIADO` char(1) DEFAULT NULL,
  `MSGERRO` varchar(500) DEFAULT NULL,
  `CAMINHOARQUIVO` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK__notificacoesresultadodetalhe__notificacoesperfil` (`ID_NOTIFICACOESPERFIL`),
  KEY `FK__notificacoesresultadodetalhe__notificacoesresultado` (`ID_NOTIFICACOESRESULTADO`),
  CONSTRAINT `FK__notificacoesresultadodetalhe__notificacoesperfil` FOREIGN KEY (`ID_NOTIFICACOESPERFIL`) REFERENCES `_notificacoesperfil` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK__notificacoesresultadodetalhe__notificacoesresultado` FOREIGN KEY (`ID_NOTIFICACOESRESULTADO`) REFERENCES `_notificacoesresultado` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11506575 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametro` (
  `PAR_ID` int(11) NOT NULL DEFAULT '0',
  `PAR_MASCARACNPJ` varchar(30) DEFAULT NULL,
  `TIPOLINGUAGEM` varchar(30) DEFAULT NULL,
  `PAR_MASCARACNPF` varchar(20) DEFAULT NULL,
  `PAR_MASCARACEP` varchar(10) DEFAULT NULL,
  `PAR_MASCARAFONEFAX` varchar(20) DEFAULT NULL,
  `PAR_CODIGO` varchar(10) DEFAULT NULL,
  `PAR_VALOR` varchar(20) DEFAULT NULL,
  `PAR_PERCENTUAL` varchar(20) DEFAULT NULL,
  `PAR_MASCARAVLRCUSMAQACAB` varchar(16) DEFAULT NULL,
  `PAR_MASCARAMEDMAQ` varchar(16) DEFAULT NULL,
  `PAR_MASCARAVLRCUSMATERIAL` varchar(16) DEFAULT NULL,
  `PAR_MASCARAVLRUNISERVICO` varchar(50) DEFAULT NULL,
  `PAR_MASCARAVLRSUBTOTORC` varchar(50) DEFAULT NULL,
  `PAR_MASCARAVLRTOTORC` varchar(50) DEFAULT NULL,
  `PAR_MASCARAVLRUNITOTORC` varchar(50) DEFAULT NULL,
  `PAR_MASCARAFATORABSORCAO` varchar(16) DEFAULT NULL,
  `PAR_MASCARAQTTINTA` varchar(16) DEFAULT NULL,
  `PAR_TIRARETIRAMIOLO` char(1) DEFAULT NULL,
  `FATURARPRODSEMESTOQUE` char(1) DEFAULT NULL,
  `PAR_TIRARETIRAMIOLOADIC` char(1) DEFAULT NULL,
  `CARREGAVLUNITPRIMSERVGERAL` char(1) DEFAULT NULL,
  `QTDIASGERARPLANEJENTPADRAO` double(18,8) DEFAULT NULL,
  `PAR_ADICIONARPERDATIRAGEM` char(1) DEFAULT NULL,
  `CALCSOMENTEIRORCPAPELIMUNE` char(1) DEFAULT NULL,
  `PAR_MASCARAQTCONSUMOMPMAQACAB` varchar(16) DEFAULT NULL,
  `PAR_ADICIONARACERTOTIRAGEM` char(1) DEFAULT NULL,
  `HABILITARMOVCONTMANUAL` char(1) DEFAULT NULL,
  `ALTPEDCOMPRADPSENTFEITA` char(1) DEFAULT NULL,
  `NAOCONTROLASALDOPCENTRADAMAT` char(1) DEFAULT NULL,
  `ALTERAQTITEMPCENTRADAMAT` char(1) DEFAULT NULL,
  `HABILITARMASCCODPESSOA` char(1) DEFAULT NULL,
  `TAMANHOMAXCODPESSOA` int(11) DEFAULT NULL,
  `PREFIXOCODPESSOA` varchar(20) DEFAULT NULL,
  `GERASOMENTEUMAOSPORORC` char(1) DEFAULT NULL,
  `HABILITACOPIATODASLAMINAS` char(1) DEFAULT NULL,
  `HABILITACALCISSPAPELIMUNE` char(1) DEFAULT NULL,
  `HABILITAORDENACAONUMCOD` char(1) DEFAULT NULL,
  `VERIFICASALDOITENSOP` char(1) DEFAULT NULL,
  `NAOALTERAORCCOMPROPOSTA` char(1) DEFAULT NULL,
  `TIPOASSUNTOEMAIL` varchar(25) DEFAULT NULL,
  `ASSUNTOEMAILPREDEFINIDO` varchar(60) DEFAULT NULL,
  `HABILITAGRADECOMP` char(1) DEFAULT NULL,
  `RECVLRUNITCONFPERCITEMNF` char(1) DEFAULT NULL,
  `NAOINCLUIRPERCFMCONTMARG` char(1) DEFAULT NULL,
  `PAR_MASCARAVLRCONSUMOMPMAQACAB` varchar(16) DEFAULT NULL,
  `PAR_MASCARAGRAMATURA` varchar(16) DEFAULT NULL,
  `HABILITAIEPAPELPORQT` char(1) DEFAULT NULL,
  `HABILITAOPMULTIENTREGA` char(1) DEFAULT NULL,
  `INTERVALOLOTE` int(11) DEFAULT NULL,
  `NUMEROLOTE` int(11) DEFAULT NULL,
  `HABILITACOMPOSICAO` char(1) DEFAULT NULL,
  `TIPOACERTOLAVACAO` varchar(20) DEFAULT NULL,
  `CONFIRMARQUANTIDADE` char(1) DEFAULT NULL,
  `ARREDONDARVALORESORCAMENTO` char(1) DEFAULT NULL,
  `AMBIENTENFE` varchar(15) DEFAULT NULL,
  `AMBIENTENFCE` varchar(15) DEFAULT NULL,
  `AMBIENTENFSE` varchar(15) DEFAULT NULL,
  `VISUALIZARDANFE` char(1) DEFAULT NULL,
  `USARNROPROPOSTA` char(1) DEFAULT NULL,
  `USARDATAHORAPROPOSTA` char(1) DEFAULT NULL,
  `GERARNOVORECIBOCANCELAR` char(1) DEFAULT NULL,
  `BAIXARFATURAVISTA` char(1) DEFAULT NULL,
  `PAR_HABILITACONTROLEVENDEDOR` char(1) DEFAULT NULL,
  `NAOALTERAORCORDEMSERVICO` char(1) DEFAULT NULL,
  `PAR_MASCARAVLRPAPEL` varchar(16) DEFAULT NULL,
  `NAOPERMITIRALTERAROPFATURADA` char(1) DEFAULT NULL,
  `NUMTENTATIVASCONCORRENCIA` int(10) DEFAULT NULL,
  `TEMPOTENTAVIVASCONCORRENCIA` int(10) DEFAULT NULL,
  `HABILITARCONCORRENCIA` char(1) DEFAULT NULL,
  `PAR_COPIAOCULTACOMISSIONADOS` char(1) DEFAULT NULL,
  `PAR_MASCARAQTD` varchar(50) DEFAULT NULL,
  `PAR_CONTROLARCNPJCLIENTE` char(1) DEFAULT NULL,
  `AMBIENTERECOPI` varchar(15) DEFAULT NULL,
  `INJETORPINVALIDADO` char(1) DEFAULT NULL,
  `PROBLEMAINJETORPIN` char(1) DEFAULT NULL,
  `MANTERCHAPAPRIMLOTEOP` char(1) DEFAULT NULL,
  `LOGCADASTRO` varchar(200) DEFAULT NULL,
  `STATUSPROPOSTAOBRIGATORIO` char(1) DEFAULT NULL,
  `VERIFICASALDOITENSNC` char(1) DEFAULT NULL,
  `NEGOCIACAOCOMERCIALPADRAO` varchar(30) DEFAULT NULL,
  `PERTIMIRALTERARORCOP` char(1) DEFAULT NULL,
  `CLASSIFICACAOOPOBRIGATORIO` char(1) DEFAULT NULL,
  `CONCIDERADIASUTEIS` char(1) DEFAULT NULL,
  `TIPODATAVENCIMENTOPARC` varchar(15) DEFAULT NULL,
  `GERARCODIGOAUTOMATICOORCOP` char(1) DEFAULT NULL,
  `CONTAPADRAOOBRIGATORIO` char(1) DEFAULT NULL,
  `FORMAPAGAMENTOOBRIGATORIO` char(1) DEFAULT NULL,
  `ATIVIDADEOBRIGATORIA` char(1) DEFAULT NULL,
  `VENDEDOROBRIGATORIOCLIENTE` char(1) DEFAULT NULL,
  `POR_NAOALTERARVENDEDORCLIORC` char(1) DEFAULT NULL,
  `DESCONSIDERARPERCMRGLUCMIN` char(1) DEFAULT NULL,
  `DIRETORIOEPED` varchar(250) DEFAULT NULL,
  `FINALIZARNEGOCIACAOGERAROP` char(1) DEFAULT NULL,
  `PERMITIRBAIXAROPACIMASALDO` char(1) DEFAULT NULL,
  `PER_IDEPED` int(11) DEFAULT NULL,
  `OBRIGADO1ENDCONTCLI` char(1) DEFAULT NULL,
  `VERIFICASALDOITENSPROPFAT` char(1) DEFAULT NULL,
  `AJUSTARENTREGAPRAZOFINPCP` char(1) DEFAULT NULL,
  `HABILITARGTIN` char(1) DEFAULT NULL,
  `UTILIZARCERTIFICACAOFSC` char(1) DEFAULT NULL,
  `FATORABSDPADRAO` double(18,8) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAIL` int(11) DEFAULT NULL,
  `PERMITIRIMPORTACAOPARCIALTRANSF` char(1) DEFAULT NULL,
  `FORMATOENVEMAILPROPOSTA` varchar(20) DEFAULT NULL,
  `TIPOCONTAEMAIL` varchar(20) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAILMALING` int(11) DEFAULT NULL,
  `FORMATOENVEMAIL` varchar(20) DEFAULT NULL,
  `CCEMAILRELATORIO` varchar(200) DEFAULT NULL,
  `CCOEMAILRELATORIO` varchar(200) DEFAULT NULL,
  `CCEMAILPROPOSTA` varchar(200) DEFAULT NULL,
  `CCOEMAILPROPOSTA` varchar(200) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAILPROPOSTA` int(11) DEFAULT NULL,
  `TIPOCONTAEMAILPROPOSTA` varchar(20) DEFAULT NULL,
  `SOLICITARDESTMAILEXTERNO` char(1) DEFAULT NULL,
  `CLASSIFICACAOOPDEFAULT` varchar(10) DEFAULT NULL,
  `FILEMYSQLBININICIALREPLICADOR` varchar(70) DEFAULT NULL,
  `POSITIONBININICIALREPLICADOR` varchar(40) DEFAULT NULL,
  `HABILITARALTERACAOMOVCONTABIL` char(1) DEFAULT NULL,
  `HABILITARCONCORRENCIATELAS` char(1) DEFAULT NULL,
  `USARDIRIMAGEMPADRAO` char(1) DEFAULT NULL,
  `DIRIMAGEMLAYOUT` varchar(250) DEFAULT NULL,
  `VALIDARVIRADA_OP` varchar(1) DEFAULT NULL,
  `VALIDARVIRADA_NF` varchar(1) DEFAULT NULL,
  `VALIDARVIRADA_CP` varchar(1) DEFAULT NULL,
  `VALIDARVIRADA_CR` varchar(1) DEFAULT NULL,
  `LIMITARCREDITOCLIHABILITADO` char(1) DEFAULT NULL,
  `PAR_ADICIONARARREDTIRAGEM` char(1) DEFAULT NULL,
  `VALORLIMITECREDITOCLI` double(18,8) DEFAULT NULL,
  `DIASVALIDADELIMITECREDITOCLI` int(11) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAILSATISF` int(11) DEFAULT NULL,
  `ABRIRNEGOCIACAODUPLICARORC` char(1) DEFAULT NULL,
  `ZERARDESCONTODUPLICARORC` char(1) DEFAULT NULL,
  `SUBDOMINIOPESQUISASATISFACAO` varchar(80) DEFAULT NULL,
  `ABRIRFEEDSEMPREBROWSER` char(1) DEFAULT NULL,
  `HABILITARREPLICADOR` char(1) DEFAULT NULL,
  `CRYPTO_SSLLIB` varchar(15) DEFAULT NULL,
  `CRYPTO_CRYPTLIB` varchar(15) DEFAULT NULL,
  `CRYPTO_HTTPLIB` varchar(15) DEFAULT NULL,
  `CRYPTO_XMLSIGNLIB` varchar(15) DEFAULT NULL,
  `CRYPTO_SSLTYPE` varchar(15) DEFAULT NULL,
  `DATAHORAATUALIZACAOAUTOMATICA` datetime DEFAULT NULL,
  `IDPERFILNOTIFICACAOEMAILATUAL` int(11) DEFAULT NULL,
  `AMBIENTEMDFE` varchar(15) DEFAULT NULL,
  `USARCONSULTAACBR` char(1) DEFAULT NULL,
  `SERVICOCONSULTACEP` char(20) DEFAULT NULL,
  `DATAULTIMAEXECIBPT` datetime DEFAULT NULL,
  PRIMARY KEY (`PAR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametroempresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametroempresa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PAR_IDCONTAPADRAOEMAILBOLETO` int(11) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAILNFE` int(10) DEFAULT NULL,
  `PAR_IDCONTAPADRAOEMAILARTE` int(10) DEFAULT NULL,
  `ASSUNTOEMAILARTE` varchar(150) DEFAULT NULL,
  `TEXTOEMAILARTE` longtext,
  `PAR_IDCONTAPADRAOEMAILDESPACHOENCOMENDAS` int(10) DEFAULT NULL,
  `ASSUNTOEMAILDESPACHOENCOMENDAS` varchar(150) DEFAULT NULL,
  `TEXTOEMAILDESPACHOENCOMENDAS` longtext,
  `ENVIAREMAILDESPACHOENCOMENDAS` char(1) DEFAULT NULL,
  `PAR_DESPENCCODAGACORREIO` varchar(20) DEFAULT NULL,
  `PAR_DESPENCLOGINCORREIO` varchar(20) DEFAULT NULL,
  `PAR_DESPENCSENHACORREIO` varchar(20) DEFAULT NULL,
  `CHAVEACESSONFSE` varchar(100) DEFAULT NULL,
  `CONTROLARLOCALESTOQUE` char(1) DEFAULT NULL,
  `DEFINIRLOCALESTOQUEMOVIMENTACAO` char(1) DEFAULT NULL,
  `CONCILIARISSRETIDONFSEVENCIMENTOS` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametroestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametroestoque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `BAIXARMANUALMENTEREQUISICAO` char(1) DEFAULT NULL,
  `GERARREQESTOQUEAUTOMATICOS` char(1) DEFAULT NULL,
  `NAOGERARREQESTOQUETINTAS` char(1) DEFAULT NULL,
  `NAOGERARREQESTOQUEPAPEIS` char(1) DEFAULT NULL,
  `NAOGERARREQESTOQUEMATDIV` char(1) DEFAULT NULL,
  `NAOGERARREQESTOQUECHAPAS` char(1) DEFAULT NULL,
  `PERFILCOBRANCAOBRIGATORIOEST` char(1) DEFAULT NULL,
  `JUSTIFICATIVAOBRIGESTOQUE` char(1) DEFAULT NULL,
  `NAOALTERARPAPELOPBAIXAREQ` char(1) DEFAULT NULL,
  `NAOBAIXARREQSEMSALDO` char(1) DEFAULT NULL,
  `INCLUIRNUMNFFORNTITULO` char(1) DEFAULT NULL,
  `GERARESTOQUESERVICO` char(1) DEFAULT NULL,
  `NAOGERAREQPAPELFORN` char(1) DEFAULT NULL,
  `PRECOMEDIOPELOVLRLIQUIDO` char(1) DEFAULT NULL,
  `PERMITIALTERARPRECOMEDIO` char(1) DEFAULT NULL,
  `CONTROLAESTOQUESEGURANCA` char(1) DEFAULT NULL,
  `PERCAREAIMPRESSAOTINTAS` double(18,8) DEFAULT NULL,
  `NAOATUALIZARVLRCOMPRA` char(1) DEFAULT NULL,
  `TIPOLIBERACAOPEDCOMP` char(1) DEFAULT NULL,
  `NAOBAIXARREQSEMSALDOITEMREQ` char(1) DEFAULT NULL,
  `ABATERCREDIMPOSTOPRECOMEDIO` char(1) DEFAULT NULL,
  `LOCALPADRAONFCOMPRA` int(11) DEFAULT NULL,
  `LOCALPADRAONFVENDA` int(11) DEFAULT NULL,
  `LOCALPADRAOBXOP` int(11) DEFAULT NULL,
  `LOCALPADRAOACERTOESTOQUE` int(11) DEFAULT NULL,
  `LOCALPADRAOREQESTOQUE` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametrofaturamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametrofaturamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FATURARPRODUTOSEMESTOQUE` char(1) DEFAULT NULL,
  `MULTIESTOQUE` char(1) DEFAULT NULL,
  `NOMENCLATURANF` varchar(100) DEFAULT NULL,
  `NOMENCLATURAABREVNF` varchar(15) DEFAULT NULL,
  `MASCARADOCUMENTONF` varchar(150) DEFAULT NULL,
  `SUFIXOCONJUNCOESNF` char(1) DEFAULT NULL,
  `INCORPORARIPIPRIMEIRAPARCELA` char(1) DEFAULT NULL,
  `INCORPORARFRETESEGOUTPRIMPARC` char(1) DEFAULT NULL,
  `INCORPORAVLRICMSSTPRIMPARC` char(1) DEFAULT NULL,
  `LANCAMENTOMANUALCOMISSOES` char(1) DEFAULT NULL,
  `BUSCARICMS` char(1) DEFAULT NULL,
  `ORIGEMITEMNFPADRAO` varchar(20) DEFAULT NULL,
  `TIPOFRETEPADRAO` varchar(20) DEFAULT NULL,
  `PERMFATOPACIMASALDO` char(1) DEFAULT NULL,
  `ALTERARFMPAGTOORIGEMOP` char(1) DEFAULT NULL,
  `TIPOENDERECOPADRAO` varchar(20) DEFAULT NULL,
  `TIPOCONTATOPADRAO` varchar(20) DEFAULT NULL,
  `HABILITARENDFATURPADRAO` char(1) DEFAULT NULL,
  `HABILITARCONTFATURPADRAO` char(1) DEFAULT NULL,
  `PERFILCOBRANCAOBRIGATORIOFAT` char(1) DEFAULT NULL,
  `IGNORARIPIORCOP` char(1) DEFAULT NULL,
  `NUMEROSERIECERTIFICADO` varchar(60) DEFAULT NULL,
  `DATAVENCCERTIFICADO` date DEFAULT NULL,
  `TEXTOEMAILNFE` longtext,
  `ASSUNTOEMAILNFE` varchar(150) DEFAULT NULL,
  `ENVIARDANFEEMAIL` char(1) DEFAULT NULL,
  `OBSERVACAONADANFE` varchar(30) DEFAULT NULL,
  `PAR_PERMITIRDUPLICAROPORCNF` char(1) DEFAULT NULL,
  `DESTACARISSQNNF` char(1) DEFAULT NULL,
  `REDEFINIRNUMEROTITULOS` char(1) DEFAULT NULL,
  `DESCONSIDERARPERCREDUCICMS` char(1) DEFAULT NULL,
  `VERIFICARPENDENCIASNAEMISSAONF` char(1) DEFAULT NULL,
  `CONSIDERARITEMSERVSENDOPROD` char(1) DEFAULT NULL,
  `IDRELDANFEPADRAO` int(11) DEFAULT NULL,
  `IDRELDANFEIMPRESSAO` int(11) DEFAULT NULL,
  `USARRELDANFEIMPRESSAO` char(1) DEFAULT NULL,
  `CONSIDERARVLRBRUTOCOMISSAO` char(1) DEFAULT NULL,
  `ADDNUMNFEMAILDANFE` char(1) DEFAULT NULL,
  `VERIFICASALDOITENSPEDVENDA` char(1) DEFAULT NULL,
  `IDRELRPSPADRAO` int(11) DEFAULT NULL,
  `IDRELCCEPADRAO` int(11) DEFAULT NULL,
  `USUARIONFSE` char(100) DEFAULT NULL,
  `SENHAUSUARIONFSE` char(120) DEFAULT NULL,
  `TIPOLIBERACAOPEDFAT` char(1) DEFAULT NULL,
  `TIPOLIBERACAOPEDOP` char(1) DEFAULT NULL,
  `EXPEDIRPEDIDO` char(1) DEFAULT NULL,
  `RECOPI_ULTIMOIDTESTE` int(10) DEFAULT NULL,
  `RECOPI_ULTIMOID` int(10) DEFAULT NULL,
  `HABILITARRECOPI` char(1) DEFAULT NULL,
  `PINJANELA` varchar(100) DEFAULT NULL,
  `PINSENHA` varchar(100) DEFAULT NULL,
  `PINTIPOCERTIFICADO` varchar(10) DEFAULT NULL,
  `ENVIONFEMANUAL` char(1) DEFAULT NULL,
  `NFEFORMAEMISSAO` varchar(50) DEFAULT NULL,
  `ORIGEMITEMPEDVENDAPADRAO` varchar(20) DEFAULT NULL,
  `VERIFICAREMAILCLIENTENFSE` char(1) DEFAULT NULL,
  `TIPOENVIONFSE` varchar(20) DEFAULT NULL,
  `ASSUNTOEMAILCCE` varchar(150) DEFAULT NULL,
  `ADDNUMNFEMAILCCE` char(1) DEFAULT NULL,
  `TEXTOEMAILCCE` longtext,
  `PROCESSARRPSSEQUENCIAL` char(1) DEFAULT NULL,
  `DATAVENCMAIORDATAPED` char(1) DEFAULT NULL,
  `EXIBIROBSERVACAOCLIENTE` char(1) DEFAULT NULL,
  `ENVIAREMAILCONTABILISTA` char(1) DEFAULT NULL,
  `EMAILADICIONAL` varchar(100) DEFAULT NULL,
  `NFSEMOSTRARVLUNITARIOITEM` char(1) DEFAULT NULL,
  `NFSEMOSTRARVLTOTALITEM` char(1) DEFAULT NULL,
  `ENVIAREMAILTRANSPORTADORA` char(1) DEFAULT NULL,
  `CALCULARPESOAUTOMATICO` char(1) DEFAULT NULL,
  `CONSIDERARITEMPRODSENDOSERV` char(1) DEFAULT NULL,
  `PERMITIRCANCELAREXTEMPORANEO` char(1) DEFAULT NULL,
  `MOSTRARTOTALTRIBUTOSDANFE` char(1) DEFAULT NULL,
  `ENVIARDANFECANCEMAIL` char(1) DEFAULT NULL,
  `ADDNUMNFEMAILCANC` char(1) DEFAULT NULL,
  `ASSUNTOEMAILCANC` varchar(150) DEFAULT NULL,
  `TEXTOEMAILCANC` longtext,
  `BUSCARPERCREGRASTRIB` char(1) DEFAULT NULL,
  `TIPOCARREGARCST` varchar(20) DEFAULT NULL,
  `CONSIDERARACRESDESCCOM` char(1) DEFAULT NULL,
  `NAOPERMITIRNFCONJUGADA` char(1) DEFAULT NULL,
  `MOSTRARTOTALTRIBUTOSNFSE` char(1) DEFAULT NULL,
  `MOSTRARDISPOSITIVOSLEGAIS` char(1) DEFAULT NULL,
  `PREENCHERDADOSTRANSPORTE` char(1) DEFAULT NULL,
  `ESPECIEVOLUMES` varchar(40) DEFAULT NULL,
  `NUMEROVOLUMES` int(11) DEFAULT NULL,
  `CODIGOANTT` varchar(22) DEFAULT NULL,
  `UFVEICULO` char(2) DEFAULT NULL,
  `PLACAVEICULO` varchar(20) DEFAULT NULL,
  `REDEFINIRVENCIMENTOS` char(1) DEFAULT NULL,
  `PERMITIRCANCELARFORADOPRAZO` char(1) DEFAULT NULL,
  `AUTORIZARCLIENTERESTRICAO` char(1) DEFAULT NULL,
  `MASCARAPLANOCONTAS` varchar(50) DEFAULT NULL,
  `VENDEEXTERIOR` char(1) DEFAULT NULL,
  `VERIFICASALDOITENSNF` char(1) DEFAULT NULL,
  `MOSTRARSALDOALTUALITEM` char(1) DEFAULT NULL,
  `HABILITARMANIFESTACAODEST` char(1) DEFAULT NULL,
  `BLOQUEARDATAEMISSAOFAT` char(1) DEFAULT NULL,
  `BLOQUEARDESCITEMFAT` char(1) DEFAULT NULL,
  `MOSTRARVENCIMENTOSNFSE` char(1) DEFAULT NULL,
  `VERIFICARPENDENCIASNAEMISSAOPED` char(1) DEFAULT NULL,
  `CONSIDERARFRETEDESCONTONFBALCAO` char(1) DEFAULT NULL,
  `NFCEFORMAEMISSAO` varchar(50) DEFAULT NULL,
  `IDRELDANFCEPADRAO` int(11) DEFAULT NULL,
  `USARRELDANFCEIMPRESSAO` char(1) DEFAULT NULL,
  `IDRELDANFCEIMPRESSAO` int(11) DEFAULT NULL,
  `ADDNUMNFCEMAILDANFCE` char(1) DEFAULT NULL,
  `ASSUNTOEMAILNFCE` varchar(150) DEFAULT NULL,
  `TEXTOEMAILNFCE` longtext,
  `ENVIARDANFCEEMAIL` char(1) DEFAULT NULL,
  `ENVIAREMAILNFCECONTABILISTA` char(1) DEFAULT NULL,
  `EMAILNFCEADICIONAL` varchar(100) DEFAULT NULL,
  `NFCEIDCSC` varchar(10) DEFAULT NULL,
  `NFCECSC` varchar(50) DEFAULT NULL,
  `NFCEVERSAOQRCODE` varchar(20) DEFAULT NULL,
  `INCLUIRPERCCOMISSAOPRECO` char(1) DEFAULT NULL,
  `EXIBIROBSERVACAOCLIENTEPV` char(1) DEFAULT NULL,
  `PERCCREDITOICMS` double(18,8) DEFAULT NULL,
  `INCLUIRMENSAGEMCREDITOICMS` char(1) DEFAULT NULL,
  `MENSAGEMCREDITOICMS` varchar(200) DEFAULT NULL,
  `TAMANHODESCNFSE` int(11) DEFAULT NULL,
  `NFE_ENVIARINFORESPTECNICO` char(1) DEFAULT NULL,
  `NFE_ENVIARTAGREJEICAO938` char(1) DEFAULT NULL,
  `NFSE_GERARTAGFORMAPAGTO` char(1) DEFAULT NULL,
  `NAOCONSIDERARVLRICMSBCPISCOFINS` char(1) DEFAULT NULL,
  `NAOCONSIDERARVLRICMSBCPISCOFINSCOMPRA` char(1) DEFAULT 'N',
  `NAOCONSIDERARVLRISSBCPISCOFINS` char(1) DEFAULT NULL,
  `MDFEFORMAEMISSAO` varchar(50) DEFAULT NULL,
  `IDRELDAMDFEPADRAO` int(11) DEFAULT NULL,
  `USARRELDAMDFEIMPRESSAO` char(1) DEFAULT NULL,
  `IDRELDAMDFEIMPRESSAO` int(11) DEFAULT NULL,
  `INCLUIRMENSAGEMDESONBENEF` char(1) DEFAULT NULL,
  `MENSAGEMDESONBENEF` varchar(500) DEFAULT NULL,
  `TIPOVALIDACAOCANCELAMENTONFSE` varchar(30) DEFAULT NULL,
  `VALORVALIDACAOCANCELAMENTONFSE` int(11) DEFAULT NULL,
  `PERMITEREENVIARNOTADENEGADA` varchar(1) DEFAULT 'N',
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametrofinanceiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametrofinanceiro` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOCARTEIRAPADRAO` varchar(20) DEFAULT NULL,
  `PERCJUROSRECEBATRASO` double(18,8) DEFAULT NULL,
  `CONTRAPARTIDAPAGAR` int(11) DEFAULT NULL,
  `CONTRAPARTIDARECEBER` int(11) DEFAULT NULL,
  `CONTAPADRAOJUROSPAGAR` int(11) DEFAULT NULL,
  `CONTAPADRAOJUROSRECEBER` int(11) DEFAULT NULL,
  `CONTAABATRECEBIDOS` int(11) DEFAULT NULL,
  `CONTAABATCONCEDIDOS` int(11) DEFAULT NULL,
  `CONTALANCOMISSEFETIVAR` int(11) DEFAULT NULL,
  `CONTALANCOMISSPAGAR` int(11) DEFAULT NULL,
  `PRIMEIRAEXECMODFINANCEIRO` char(1) DEFAULT NULL,
  `CONTADESPESACOMISSOES` int(11) DEFAULT NULL,
  `CONTRAPARTIDATRANSF` int(11) DEFAULT NULL,
  `TIPODOCUMENTO` varchar(20) DEFAULT NULL,
  `TIPOPAGAMENTOPADRAO` varchar(20) DEFAULT NULL,
  `MEIOSPAGAMENTOPADRAO` varchar(20) DEFAULT NULL,
  `DESCAUTOMATICAHISTORICO` varchar(250) DEFAULT NULL,
  `CONTABANCARIAPADRAO` varchar(20) DEFAULT NULL,
  `CONTABANCARIAPAGARPADRAO` varchar(20) DEFAULT NULL,
  `USARCONTAVENDEDORCOMISSAO` char(1) DEFAULT NULL,
  `EFETIVACOMISSAOPROVLRBAIXA` char(1) DEFAULT NULL,
  `CONSIDERARVLRTOTALCOMISSAO` char(1) DEFAULT NULL,
  `NAOCONSIDERARRETISSCOMISSAO` char(1) DEFAULT NULL,
  `NAOCONSIDERARJUROSCOMISSAO` char(1) DEFAULT NULL,
  `NAOCONSIDERAIPICOMISSAO` char(1) DEFAULT NULL,
  `CONTROLARCHEQUE` char(1) DEFAULT NULL,
  `EFETIVARCOMISSAOCOMPCHEQUE` char(1) DEFAULT NULL,
  `IMPRIMIRNUMNFBOLETO` char(1) DEFAULT NULL,
  `PERMISSAOCONTASBANCARIASUSUARIO` char(1) DEFAULT NULL,
  `PERCMULTARECEATRASO` double(18,8) DEFAULT NULL,
  `COPIAOBSPEDIDOPARACP` char(1) DEFAULT NULL,
  `ASSUNTOEMAILBOLETO` varchar(150) DEFAULT NULL,
  `TEXTOEMAILBOLETO` longtext,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRAPADRAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametroimposto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametroimposto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CREDPISCOFINSPAPEL` char(1) DEFAULT NULL,
  `CREDPISCOFINSTINTA` char(1) DEFAULT NULL,
  `CREDPISCOFINSCHAPA` char(1) DEFAULT NULL,
  `CREDPISCOFINSMATERIAL` char(1) DEFAULT NULL,
  `CREDPISCOFINSFACA` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametroscalculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametroscalculo` (
  `PAR_INDEX` int(11) NOT NULL DEFAULT '0',
  `PAR_TIPOCALCPAPEL` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`PAR_INDEX`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametroscrm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametroscrm` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PCR_ID` int(11) NOT NULL DEFAULT '0',
  `PCR_IDLISTAATENDIMENTO` int(11) DEFAULT NULL,
  `PCR_PERCMAXCADCLIDES` double(18,8) DEFAULT NULL,
  `PCR_REGRASCADCLI` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PCR_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametrosorc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametrosorc` (
  `EMP_ID` varchar(20) NOT NULL DEFAULT '',
  `POR_AREAIMPRESSAO` double(18,8) DEFAULT NULL,
  `POR_DIASVALIDADEORC` int(11) DEFAULT NULL,
  `POR_MARGEMLUCRO` double(18,8) DEFAULT NULL,
  `VEN_ID` varchar(20) DEFAULT NULL,
  `POR_MARGEMLUCROMINIMA` double(18,8) DEFAULT NULL,
  `POR_TIPOLUCRO` varchar(10) DEFAULT NULL,
  `POR_TPCALC_COMISSAO` varchar(10) DEFAULT NULL,
  `POR_MEDIDASANGRIA` double(18,8) DEFAULT NULL,
  `POR_TIRARETIRA` char(1) DEFAULT NULL,
  `POR_TIRARETIRACORES` char(1) DEFAULT NULL,
  `POR_NAOCALCULARTEMPOMINIMO` char(1) DEFAULT NULL,
  `POR_TIPOCALCULOFORMAPAGTO` varchar(15) DEFAULT NULL,
  `POR_VERIFICAPINCA` char(1) DEFAULT NULL,
  `FOP_ID` varchar(20) DEFAULT NULL,
  `POR_MARGEMGERENTE` double(18,8) DEFAULT NULL,
  `ORCTIPOSERVICO` char(1) DEFAULT NULL,
  `PERCALIQSIMPLESFED` double(18,8) DEFAULT NULL,
  `PROP_VALIDADEDIAS` int(11) DEFAULT NULL,
  `PROP_QTDIASPRAZOENT` int(11) DEFAULT NULL,
  `VERIFICARPENDENCIASNAEMISSAOORC` char(1) DEFAULT NULL,
  `TRATARQTDMELHORAPROVORCLFEXO` char(1) DEFAULT NULL,
  `EXIBIROBSERVACAOCLIENTEORC` char(1) DEFAULT NULL,
  `GERARNOVOPRODUTOOP` char(1) DEFAULT NULL,
  `BAIXAROPAUTOMATICAMENTE` char(1) DEFAULT NULL,
  `ATUALIZARVLRSALVAROP` char(1) DEFAULT NULL,
  `ORIGEMVALORFATURAMENTO` varchar(30) DEFAULT NULL,
  `GRUPOPRODPADRAOOP` varchar(30) DEFAULT NULL,
  `PERMITIRMONTAGEMDOBRAMIOLO` char(1) DEFAULT NULL,
  `EXIBIROBSERVACAOCLIENTEOP` char(1) DEFAULT NULL,
  `CALCULARIPIPORFORA` char(1) DEFAULT 'N',
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametrosorcflexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametrosorcflexo` (
  `EMP_ID` varchar(20) NOT NULL DEFAULT '',
  `POR_MARGEMLUCRO` double(18,8) DEFAULT NULL,
  `POR_MARGEMLUCROMINIMA` double(18,8) DEFAULT NULL,
  `POR_MARGEMGERENTE` double(18,8) DEFAULT NULL,
  `UTILIZACLASSIFICACAOPADRAO` char(1) DEFAULT NULL,
  `CLASSIFICACAOPADRAO` int(4) DEFAULT NULL,
  `POR_TIPOLUCROFLEXO` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_parametrospcp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_parametrospcp` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PERMITIRAPONTTODOSFILA` char(1) DEFAULT NULL,
  `TEMPOMINIMOEXECUCAO` int(11) DEFAULT NULL,
  `MOVERTRABALHOTOTALINICIOFILA` char(1) DEFAULT NULL,
  `OCULTAROCUPACAOEQUIPAMENTO` char(1) DEFAULT NULL,
  `APONTARPROCESSOMESMOTRABALHO` char(1) DEFAULT NULL,
  `MANTERDEPENDENCIAREMANEJAR` char(1) DEFAULT NULL,
  `OCULTARJAHEXECUTADOS` char(1) DEFAULT NULL,
  `TIPOPROGRAMACAO` char(1) DEFAULT NULL,
  `TEMPOINTERVALOPROXIMATAREFA` int(11) DEFAULT NULL,
  `DATAULTIMAREPROGRAMACAO` datetime DEFAULT NULL,
  `MODOAPONTAMENTO` char(1) DEFAULT NULL,
  `PERMITIRPROGRAMARMANUAL` char(1) DEFAULT NULL,
  `PERMITIRAPONTARVARIOSPROCTRAB` char(1) DEFAULT NULL,
  `AGRUPARVIASCOMPBLOCO` char(1) DEFAULT NULL,
  `SENHAPARAAPONTAR` char(1) DEFAULT NULL,
  `PERMITIRAPTVAROPMESMOEQUIP` char(1) DEFAULT NULL,
  `MOSTRARCLIENTEQUADROGERAL` char(1) DEFAULT NULL,
  `TAMANHOFONTEQUADROGERAL` int(11) DEFAULT NULL,
  `TEMPOROLAGEMQUADROGERAL` int(11) DEFAULT NULL,
  `NOMEFONTEQUADROGERAL` varchar(50) DEFAULT NULL,
  `EQUIPAMENTOSQUADROGERAL` varchar(100) DEFAULT NULL,
  `TEMPOENTREGA_NIVEL1` double DEFAULT NULL,
  `TEMPOENTREGA_NIVEL2` double DEFAULT NULL,
  `TEMPOENTREGA_NIVEL3` double DEFAULT NULL,
  `TEMPOENTREGA_NIVEL4` double DEFAULT NULL,
  `TEMPOENTREGA_NIVEL5` double DEFAULT NULL,
  `EXIGIRLOGINNOVOAPONTAMENTO` char(1) DEFAULT NULL,
  `PRODUCAOUNIFICADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_replicadorempresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_replicadorempresa` (
  `CODIGOPERFIL` int(10) NOT NULL,
  `CODIGO` int(10) NOT NULL,
  `EMP_ID` int(10) NOT NULL,
  PRIMARY KEY (`CODIGO`,`CODIGOPERFIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_replicadorexclusao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_replicadorexclusao` (
  `CODIGO` int(10) NOT NULL AUTO_INCREMENT,
  `NOMETABELA` varchar(100) NOT NULL,
  `CHAVES` varchar(100) NOT NULL,
  `VALORES` varchar(100) NOT NULL,
  `DATA_EXCLUSAO` datetime NOT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_replicadorlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_replicadorlog` (
  `CODIGOPERFIL` int(10) NOT NULL,
  `CODIGO` int(10) NOT NULL,
  `NOMETABELA` varchar(100) NOT NULL,
  `DATAHORAPROCESSAMENTOINSERT` datetime NOT NULL,
  `DATAHORAPROCESSAMENTODELETE` datetime NOT NULL,
  PRIMARY KEY (`CODIGO`,`CODIGOPERFIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_replicadorperfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_replicadorperfil` (
  `CODIGOPERFIL` int(11) NOT NULL,
  `DESCRICAOPERFIL` varchar(100) NOT NULL,
  `ATIVADO` char(1) NOT NULL,
  PRIMARY KEY (`CODIGOPERFIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_replicadortabela`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_replicadortabela` (
  `CODIGOPERFIL` int(11) NOT NULL,
  `CODIGO` int(10) NOT NULL,
  `NOMETABELAPRINCIPAL` varchar(100) NOT NULL,
  `TABELASDEPENDENTES` varchar(300) NOT NULL,
  PRIMARY KEY (`CODIGO`,`CODIGOPERFIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_seggrupousuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_seggrupousuario` (
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `GU_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`GU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_seggrupousuariovendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_seggrupousuariovendedor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `VEN_ID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`GU_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkGrupoUsuario` (`GU_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segpermissoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segpermissoes` (
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `FUNCAO_ID` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOFUNCAO` varchar(200) NOT NULL,
  `USU_ID` int(11) DEFAULT NULL,
  `INCLUIR` char(1) DEFAULT NULL,
  `ALTERAR` char(1) DEFAULT NULL,
  `EXCLUIR` char(1) DEFAULT NULL,
  `EXECUTAR` char(1) DEFAULT NULL,
  `IMPRIMIR` char(1) DEFAULT NULL,
  `ENVIAREMAILREL` char(1) DEFAULT NULL,
  `EXPORTAR` char(1) DEFAULT NULL,
  PRIMARY KEY (`PER_ID`,`GU_ID`,`FUNCAO_ID`),
  KEY `fkSegGrupoUsu` (`GU_ID`),
  KEY `fkUsuario` (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segpermissoesacoesespeciais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segpermissoesacoesespeciais` (
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `FUNCAO_ID` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `USU_ID` int(11) DEFAULT NULL,
  `DESCRICAOFUNCAO` varchar(200) NOT NULL,
  `TIPO` varchar(40) DEFAULT NULL,
  `VALOR` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`PER_ID`,`GU_ID`,`FUNCAO_ID`,`SEQUENCIAL`),
  KEY `fkSegGrupoUsu` (`GU_ID`),
  KEY `fkUsuario` (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segpermissoesconspersonalizada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segpermissoesconspersonalizada` (
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL,
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `USU_ID` int(11) DEFAULT NULL,
  `EXECUTAR` char(1) DEFAULT NULL,
  `IMPRIMIR` char(1) DEFAULT NULL,
  `ENVIAREMAILREL` char(1) DEFAULT NULL,
  `EXPORTAR` char(1) DEFAULT NULL,
  PRIMARY KEY (`PER_ID`,`CODIGO`,`GU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segpermissoesrelpersonalizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segpermissoesrelpersonalizado` (
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `BRP_PASTAID` int(11) NOT NULL,
  `BRI_ITEMID` int(11) NOT NULL,
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `USU_ID` int(11) DEFAULT NULL,
  `EXECUTAR` char(1) DEFAULT NULL,
  `IMPRIMIR` char(1) DEFAULT NULL,
  `ENVIAREMAILREL` char(1) DEFAULT NULL,
  `EXPORTAR` char(1) DEFAULT NULL,
  PRIMARY KEY (`PER_ID`,`BRP_PASTAID`,`BRI_ITEMID`,`GU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segusuario` (
  `USU_ID` int(11) NOT NULL DEFAULT '0',
  `USU_NOME` varchar(30) NOT NULL DEFAULT '',
  `USU_LOGIN` varchar(20) NOT NULL DEFAULT '',
  `USU_SENHA` varchar(30) NOT NULL DEFAULT '',
  `USU_STATUS` char(1) NOT NULL DEFAULT '',
  `GU_ID` int(11) NOT NULL DEFAULT '0',
  `USU_EMAIL` int(11) DEFAULT NULL,
  `RAMAL` varchar(20) NOT NULL DEFAULT '',
  `USU_SENHA2` varchar(40) NOT NULL DEFAULT '',
  `USU_PERCMAXDESCONTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `USU_CONTROLAATUALIZACAO` char(1) NOT NULL,
  PRIMARY KEY (`USU_ID`),
  KEY `fkSegGrupoUsu` (`GU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segusuario2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segusuario2` (
  `USU_ID` int(11) NOT NULL DEFAULT '0',
  `USU_LOGIN` varchar(40) NOT NULL DEFAULT '',
  `USU_SENHA` varchar(40) NOT NULL DEFAULT '',
  `USU_NIVEL` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segusuarioempresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segusuarioempresa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `USU_ID` int(11) NOT NULL DEFAULT '0',
  `VEN_ID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`USU_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_segusuariomodulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_segusuariomodulo` (
  `USU_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMODULO` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`USU_ID`,`CODIGOMODULO`),
  KEY `fkUsuario` (`USU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_traducao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_traducao` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PT_BRA` mediumtext NOT NULL,
  `ES_ARG` mediumtext,
  `ES_PAR` mediumtext,
  `EN_EUA` mediumtext,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1873 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_vpesquisamateriais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_vpesquisamateriais` (
  `EMP_ID` int(11) NOT NULL,
  `MTR_ID` varchar(20) NOT NULL,
  `MTRLVL` int(11) NOT NULL,
  `MTR_SEQAPRES` int(11) NOT NULL,
  `MTR_DESCRICAO` varchar(500) NOT NULL,
  `MTR_IDPAI` varchar(20) DEFAULT NULL,
  `MTR_CODREF` varchar(35) DEFAULT NULL,
  `MTR_TIPO` varchar(20) DEFAULT NULL,
  `MTR_DESATIVADO` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_vpesquisaprodutos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_vpesquisaprodutos` (
  `EMP_ID` int(11) NOT NULL,
  `MTR_ID` varchar(20) NOT NULL,
  `MTRLVL` int(11) NOT NULL,
  `MTR_SEQAPRES` int(11) NOT NULL,
  `MTR_DESCRICAO` varchar(500) NOT NULL,
  `MTR_IDPAI` varchar(20) DEFAULT NULL,
  `MTR_CODREF` varchar(35) DEFAULT NULL,
  `MTR_TIPO` varchar(20) DEFAULT NULL,
  `MTR_DESATIVADO` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `_vpesquisaservicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_vpesquisaservicos` (
  `EMP_ID` int(11) NOT NULL,
  `MTR_ID` varchar(20) NOT NULL,
  `MTRLVL` int(11) NOT NULL,
  `MTR_SEQAPRES` int(11) NOT NULL,
  `MTR_DESCRICAO` varchar(500) NOT NULL,
  `MTR_IDPAI` varchar(20) DEFAULT NULL,
  `MTR_CODREF` varchar(35) DEFAULT NULL,
  `MTR_TIPO` varchar(20) DEFAULT NULL,
  `MTR_DESATIVADO` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `acertoestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acertoestoque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ACERTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAOPERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TIPOOPERACAO` char(1) NOT NULL DEFAULT '',
  `ORIGEMMATERIAL` char(1) NOT NULL DEFAULT '',
  `CODIGOMATERIAL` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOMATERIAL` varchar(200) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `MOVIMENTARVALORMEDIO` char(1) NOT NULL DEFAULT 'N',
  `UNIDADE` varchar(10) DEFAULT NULL,
  `JUSTIFICATIVA` varchar(100) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` varchar(100) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAGRAVACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CODTIPOMOVESTOQUE` varchar(20) DEFAULT NULL,
  `LOC_ID` int(11) DEFAULT NULL,
  `CODIGOLOTE` varchar(40) DEFAULT NULL,
  `IND_EST` int(11) DEFAULT NULL,
  `COD_PART` varchar(60) DEFAULT NULL,
  `FATORCONVERSAO` float(18,8) DEFAULT NULL,
  `IDACERTOESTOQUEPAI` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ACERTO_ID`),
  KEY `akEstoque1` (`EMP_ID`,`TIPOOPERACAO`,`ORIGEMMATERIAL`,`CODIGOMATERIAL`),
  KEY `akEstoque2` (`EMP_ID`,`ORIGEMMATERIAL`,`CODIGOMATERIAL`,`TIPOOPERACAO`,`DATAOPERACAO`,`CANCELADO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `arquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arquivos` (
  `ID_ARQUIVO` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA_ANEXO` datetime NOT NULL,
  `IDENTIFICADOR` varchar(50) NOT NULL DEFAULT '',
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LOCALIZACAOARQUIVO` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID_ARQUIVO`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `atividade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atividade` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ATI_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ATI_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `ATI_DESATIVADA` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ATI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ativoimobilizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ativoimobilizado` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOATIVOIMOBILIZADO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCENTROCUSTO` int(11) NOT NULL DEFAULT '0',
  `DATAAQUISICAO` date NOT NULL,
  `HORASUTEISEQUIPMENSAL` int(11) NOT NULL DEFAULT '0',
  `TEMPODEPRECIACAO` int(11) NOT NULL DEFAULT '0',
  `DATAFINALDEPRECIACAO` date NOT NULL,
  `VALORREPOSICAO` double(18,8) NOT NULL,
  `VALORRESIDUAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOATIVOIMOBILIZADO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `autorizacaopagto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autorizacaopagto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `NOMEPESSOA` varchar(50) NOT NULL DEFAULT '',
  `DATAEMISSAO` datetime DEFAULT NULL,
  `DATAVENCIMENTO` datetime DEFAULT NULL,
  `NUMEROTITULO` varchar(50) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  `DESCRICAOHISTORICO` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOUSUARIO`,`CHAVE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkFinanceiro` (`EMP_ID`,`CHAVE`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `banco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banco` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `NUMEROBANCO` int(11) NOT NULL DEFAULT '0',
  `NUMEROAGENCIA` int(11) NOT NULL DEFAULT '0',
  `FONE1` varchar(18) DEFAULT NULL,
  `FONE2` varchar(18) DEFAULT NULL,
  `CONTATO1` varchar(50) DEFAULT NULL,
  `CONTATO2` varchar(50) DEFAULT NULL,
  `DIGITOAGENCIA` char(2) NOT NULL,
  `CONTATO3` varchar(50) DEFAULT NULL,
  `FONE3` varchar(18) DEFAULT NULL,
  `EMAIL3` varchar(100) DEFAULT NULL,
  `EMAIL2` varchar(100) DEFAULT NULL,
  `EMAIL1` varchar(100) DEFAULT NULL,
  `BOLETO_CODIGOBANCO` varchar(7) DEFAULT NULL,
  `BOLETO_NOMEBANCO` varchar(100) DEFAULT NULL,
  `BOLETO_LOCALPAGAMENTO` varchar(100) DEFAULT NULL,
  `BOLETO_ESPECIEMOEDA` char(2) DEFAULT NULL,
  `BOLETO_QUANTIDADEMOEDA` int(11) DEFAULT NULL,
  `BOLETO_VALORMOEDA` double(18,8) DEFAULT NULL,
  `BOLETO_IDREL` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `baseconhecimentodocseletronicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `baseconhecimentodocseletronicos` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPODOCELETRONICO` int(11) NOT NULL COMMENT '1 = Nfe, 2 = Nfse, 3 = NFCe',
  `CODIGOREJEICAO` int(11) NOT NULL DEFAULT '0',
  `MSGREJEICAO` longtext NOT NULL,
  `REGRAS` longtext,
  `ORIENTACAO` longtext,
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`),
  KEY `akCodigoRejeicao` (`TIPODOCELETRONICO`,`CODIGOREJEICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beneficiofiscal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beneficiofiscal` (
  `ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EST_SIGLA` char(2) NOT NULL,
  `CST` varchar(5) DEFAULT '',
  `CBENEF` varchar(10) NOT NULL DEFAULT '',
  `DATAINICIO` datetime DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=2026 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `blocok`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocok` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DT_INICIALAPUR` date NOT NULL,
  `DT_FINALAPUR` date NOT NULL,
  `NOMEUSUARIO` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `blocokitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocokitem` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDBLOCOK` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `COD_ITEM` varchar(20) DEFAULT NULL,
  `QTD` double(18,8) DEFAULT NULL,
  `IND_EST` int(11) DEFAULT NULL,
  `COD_PART` varchar(60) DEFAULT NULL,
  `ORIGEMITEM` varchar(2) DEFAULT NULL,
  `DESCRICAOITEM` varchar(100) NOT NULL,
  `TIPOITEM` varchar(2) DEFAULT NULL,
  `UNIDADE` varchar(20) DEFAULT NULL,
  `NCM` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkBlocK` (`IDBLOCOK`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `campanha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campanha` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CAM_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAM_DATAFIM` date NOT NULL DEFAULT '0000-00-00',
  `CAM_DATAPREVISTA` date NOT NULL DEFAULT '0000-00-00',
  `CAM_DATAINICIO` date NOT NULL DEFAULT '0000-00-00',
  `CAM_STATUS` varchar(50) NOT NULL DEFAULT '',
  `CAM_DESCRICAO` varchar(100) NOT NULL,
  `CAM_AUTOR` varchar(50) NOT NULL DEFAULT '',
  `CAM_OBJETIVO` longtext,
  `CAM_RECEITA` double(18,8) DEFAULT NULL,
  `CAM_CUSTO` double(18,8) DEFAULT NULL,
  `CAM_LUCRO` double(18,8) DEFAULT NULL,
  `ID_PERFILSATISFACAO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CAM_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `campanhagrupocliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campanhagrupocliente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CAM_ID` int(11) NOT NULL DEFAULT '0',
  `GRC_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CAM_ID`,`GRC_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCampanha` (`EMP_ID`,`CAM_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `campanhamidia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campanhamidia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CAM_ID` int(11) NOT NULL DEFAULT '0',
  `MID_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CAM_ID`,`MID_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCampanha` (`EMP_ID`,`CAM_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOCARGO` int(11) NOT NULL DEFAULT '0',
  `ENCARGOS` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoCargo` (`EMP_ID`,`CODIGOTIPOCARGO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `carteira`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carteira` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOBANCO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOCONTABANCARIA` varchar(20) NOT NULL DEFAULT '',
  `CODIGOCEDENTE` varchar(30) DEFAULT NULL,
  `DIGITOCODIGOCEDENTE` varchar(4) DEFAULT NULL,
  `VALORTAXABORDERO` double(18,8) DEFAULT NULL,
  `VALORTAXADUPLICATA` double(18,8) DEFAULT NULL,
  `CODIGOCARTEIRA` varchar(10) DEFAULT NULL,
  `CODIGOCONVENIO` varchar(15) DEFAULT NULL,
  `POSICAOCORRENTE` int(11) NOT NULL DEFAULT '0',
  `NUMEROINICIAL` int(11) NOT NULL DEFAULT '0',
  `NUMEROFINAL` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIALREMESSA` int(11) DEFAULT NULL,
  `CONSIDERARDESPESASCOBRANCA` char(1) NOT NULL DEFAULT 'S',
  `CODIGOAGENCIACORRESP` varchar(20) DEFAULT NULL,
  `CODIGOBENEFICIARIOCORRESP` varchar(30) DEFAULT NULL,
  `DIGITOBENEFICIARIOCORRESP` varchar(4) DEFAULT NULL,
  `ESPECIEDOCUMENTO` varchar(30) NOT NULL,
  `ACEITE` char(1) NOT NULL,
  `TIPOCALCULOJUROSMORA` varchar(30) NOT NULL,
  `TIPOCALCULOMULTA` varchar(30) NOT NULL,
  `BLOQUETOPREIMPRESO` char(1) NOT NULL,
  `EMISAOBLOQUETO` varchar(30) NOT NULL,
  `PERCJUROS` double(18,8) NOT NULL,
  `PERCMULTA` double(18,8) NOT NULL,
  `INSTRUCOESREMESSABOLETO` longtext,
  `INSTRUCOESREMESSAAUXILIAR` longtext,
  `UTILIZARCODCEDENTE` char(1) NOT NULL,
  `ID_LAYOUTREMESSA` int(11) DEFAULT NULL,
  `ID_LAYOUTRETORNO` int(11) DEFAULT NULL,
  `TIPODOCUMENTOFINANCEIRO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkBanco` (`EMP_ID`,`CODIGOBANCO`),
  KEY `fkContaBancaria` (`EMP_ID`,`CODIGOCONTABANCARIA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `carteiraparametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carteiraparametros` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOCARTEIRA` varchar(5) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `REMTIPOEMISSAOBLOQ` varchar(5) DEFAULT NULL,
  `REMTIPOCADASTRAMENTO` varchar(5) DEFAULT NULL,
  `REMTIPODOCUMENTO` varchar(5) DEFAULT NULL,
  `REMTIPOACEITE` varchar(5) DEFAULT NULL,
  `REMTIPOSERVICO` varchar(5) DEFAULT NULL,
  `REMCODPROTESTO` varchar(5) DEFAULT NULL,
  `REMDIASPROTESTO` int(11) DEFAULT NULL,
  `REMCODREMESSA` varchar(5) DEFAULT NULL,
  `REMTIPOTITULO` varchar(5) DEFAULT NULL,
  `REMCODMORA` varchar(5) DEFAULT NULL,
  `REMCODDESCTO` varchar(5) DEFAULT NULL,
  `REMDIASMORA` int(11) DEFAULT NULL,
  `BOLETOPREIMP` varchar(5) DEFAULT NULL,
  `CODIGOCLIENTEBANCO` varchar(20) DEFAULT NULL,
  `CODIGOMULTA` double(18,8) DEFAULT NULL,
  `VALORMULTA` double(18,8) DEFAULT NULL,
  `QTDIASPRIMDESC` int(11) DEFAULT NULL,
  `REMCODMODALIDADE` varchar(5) DEFAULT NULL,
  `DEBITOAUTOMATICO` varchar(5) DEFAULT '02',
  `REMCODBAIXADEVOLUCAO` varchar(5) DEFAULT NULL,
  `REMDIASBAIXADEVOLUCAO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOCARTEIRA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `carteiraparametros2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carteiraparametros2` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOCARTEIRA` varchar(5) NOT NULL DEFAULT '',
  `IDPARAMETROCARTEIRA` int(11) NOT NULL,
  `CODIGOBANCO` varchar(30) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORPARAMETRO` varchar(100) NOT NULL DEFAULT '',
  `NOMEPARAMETRO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOCARTEIRA`,`IDPARAMETROCARTEIRA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `pkCodigoBanco` (`EMP_ID`,`CODIGOBANCO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CAT_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAT_IDPAI` int(11) NOT NULL DEFAULT '0',
  `CAT_DESCRICAO` varchar(100) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CAT_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `centrocusto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centrocusto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPOCENTRO` varchar(30) DEFAULT NULL,
  `UNIDADECENTRO` varchar(30) DEFAULT NULL,
  `AREACENTRO` double(18,8) DEFAULT NULL,
  `HPSCENTRO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `centrocustoreq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centrocustoreq` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CC_CODIGOREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CC_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CC_CODIGO` varchar(20) NOT NULL DEFAULT '',
  `CC_CODIGOPAI` int(11) NOT NULL DEFAULT '0',
  `CC_TIPO` varchar(20) NOT NULL DEFAULT '',
  `CC_DESATIVADA` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CC_CODIGOREDUZIDO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `centrocustorequsu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centrocustorequsu` (
  `EMP_ID` int(11) NOT NULL,
  `CC_CODIGOREDUZIDO` int(11) NOT NULL,
  `ID_USU` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CC_CODIGOREDUZIDO`,`ID_USU`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`ID_USU`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `certificadogarantia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificadogarantia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_CERTGARANTIA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `NUMEROPEDIDO` varchar(20) NOT NULL DEFAULT '',
  `DATAFABRICACAO` date NOT NULL,
  `DATAEXPEDICAO` date NOT NULL,
  `DATAENTREGA` date NOT NULL,
  `NUMEROLOTE` varchar(20) DEFAULT NULL,
  `DESCRICAOITEM` varchar(600) DEFAULT NULL,
  `COMPRIMENTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LARGURA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `GRAMATURAPAPEL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `GRAMATURAADESIVO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `GRAMATURALINER` double(18,8) NOT NULL DEFAULT '0.00000000',
  `GRAMATURATOTAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TIPOADESIVO` varchar(100) DEFAULT NULL,
  `NUMUNIDROLOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TEXTOINDEFIMP` longtext,
  `CORES` longtext,
  `SERIENF` varchar(20) DEFAULT NULL,
  `NUMERONF` int(11) DEFAULT NULL,
  `CLIENTE` varchar(100) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_CERTGARANTIA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkProduto` (`EMP_ID`,`CODIGOPRODUTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cest_ncm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cest_ncm` (
  `CEST_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CEST_CODIGO` varchar(10) NOT NULL DEFAULT '0',
  `CEST_NCM_COD` varchar(10) NOT NULL DEFAULT '0',
  `CEST_DESC` varchar(200) NOT NULL DEFAULT '0',
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`CEST_ID`),
  UNIQUE KEY `akCESTNCM1` (`CEST_CODIGO`,`CEST_NCM_COD`),
  KEY `fkNCM` (`CEST_NCM_COD`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=1534 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cfopoficial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfopoficial` (
  `CFO_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CFO_CODIGO` varchar(5) NOT NULL DEFAULT '00000',
  `CFO_ENTSAI` varchar(1) NOT NULL DEFAULT '0',
  `CFO_DESC` varchar(200) NOT NULL,
  `CFO_APLIC` varchar(200) DEFAULT NULL,
  `CFO_VISIVEL` varchar(1) NOT NULL DEFAULT 'S',
  `CFOP_TIPOOPERACAO` varchar(20) NOT NULL,
  `CFOP_COMBUSTIVEL` varchar(1) NOT NULL DEFAULT 'N',
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`CFO_ID`),
  UNIQUE KEY `akCFOPOficial1` (`CFO_CODIGO`),
  KEY `akCFOPOficial2` (`CFO_ENTSAI`),
  KEY `akCFOPOficial3` (`CFO_DESC`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=625 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cfps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cfps` (
  `CFP_ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CFP_CODIGO` varchar(5) NOT NULL DEFAULT '0.000',
  `CFP_DESC` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`CFP_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chapa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHA_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHA_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CHA_LARGURA` double(18,8) NOT NULL,
  `CHA_ALTURA` double(18,8) NOT NULL,
  `CHA_VALOR` double(18,8) NOT NULL,
  `CHA_CHAPACILINDRO` varchar(20) NOT NULL DEFAULT '',
  `CHA_DURABILIDADE` int(11) NOT NULL DEFAULT '0',
  `CHA_SALDOINICIAL` double(18,8) DEFAULT NULL,
  `CHA_QTMINIMA` double(18,8) DEFAULT NULL,
  `CHA_TEMPOACERTO` int(11) DEFAULT NULL,
  `CHA_SALDOFISICO` double(18,8) DEFAULT NULL,
  `CHA_SALDOEMPENHADO` double(18,8) DEFAULT NULL,
  `CHA_PRECOMEDIO` double(18,5) DEFAULT '0.00000',
  `CHA_CSTICMS` varchar(3) DEFAULT NULL,
  `CHA_CSTIPI` varchar(3) DEFAULT NULL,
  `CHA_CSTPIS` varchar(3) DEFAULT NULL,
  `CHA_CSTCOFINS` varchar(3) DEFAULT NULL,
  `CHA_CNAE` varchar(10) DEFAULT NULL,
  `CHA_CLASSFISCAL` varchar(10) DEFAULT NULL,
  `CHA_PERCIPI` double(18,8) DEFAULT NULL,
  `CHA_PERCICMS` double(18,8) DEFAULT NULL,
  `CHA_TIPOITEM` char(2) DEFAULT NULL,
  `CHA_SALDOEMPENHADOVENDA` double(18,8) DEFAULT NULL,
  `CHA_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `CHA_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `CHA_SALDOEMPENHADOPRODUCAO` double(18,8) DEFAULT NULL,
  `CHA_CLICK` char(1) NOT NULL,
  `CHA_VALORSEMICMSIPI` double(18,8) DEFAULT NULL,
  `CHA_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `INFORMARVALORMEDIOMANUAL` char(1) DEFAULT 'N',
  `CHA_CODPLANOCONTA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CHA_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkPlanoConta` (`EMP_ID`,`CHA_CODPLANOCONTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cheque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cheque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAEMISSAO` datetime NOT NULL,
  `DATAVENCIMENTO` datetime DEFAULT NULL,
  `CODIGOCLIENTE` varchar(20) DEFAULT NULL,
  `NOMEEMITENTE` varchar(100) DEFAULT NULL,
  `EMITENTECNPJCPF` varchar(14) DEFAULT NULL,
  `CODIGOBANCO` varchar(3) NOT NULL DEFAULT '',
  `AGENCIA` varchar(10) NOT NULL DEFAULT '',
  `NUMEROCONTA` varchar(10) DEFAULT NULL,
  `NUMEROCHEQUE` varchar(6) NOT NULL DEFAULT '',
  `CIDADECHEQUE` varchar(30) DEFAULT NULL,
  `UFCHEQUE` char(2) DEFAULT NULL,
  `VALORTOTAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `STATUS` varchar(30) NOT NULL,
  `TIPO` varchar(30) NOT NULL,
  `CODIGOCONTABANCARIA` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CHE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CODIGOCLIENTE`),
  KEY `fkBanco` (`EMP_ID`,`CODIGOBANCO`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkContaBancaria` (`EMP_ID`,`CODIGOCONTABANCARIA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chequebaixas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chequebaixas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHE_ID` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `CHAVEBAIXAPAGAR` int(11) NOT NULL DEFAULT '0',
  `CHAVEBAIXARECEBER` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CHE_ID`,`CHAVE`,`CHAVEBAIXAPAGAR`,`CHAVEBAIXARECEBER`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCheque` (`EMP_ID`,`CHE_ID`),
  KEY `fkFinanceiro` (`EMP_ID`,`CHAVE`),
  KEY `fkPagar` (`EMP_ID`,`CHAVEBAIXAPAGAR`),
  KEY `fkReceber` (`EMP_ID`,`CHAVEBAIXARECEBER`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cidade` (
  `CID_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EST_SIGLA` char(2) NOT NULL DEFAULT '',
  `COD_IBGE` varchar(7) NOT NULL DEFAULT '',
  `NOME_CIDADE` varchar(50) NOT NULL DEFAULT '',
  `NOME_CIDADE_EX` varchar(50) NOT NULL DEFAULT '',
  `COD_SIAFI` varchar(4) NOT NULL DEFAULT '',
  `CAPITAL` char(1) NOT NULL DEFAULT 'N',
  `FRONTEIRA` char(1) NOT NULL DEFAULT 'N',
  `AMAZONIA` char(1) NOT NULL DEFAULT 'N',
  `COD_ANEXOANFSE` int(11) NOT NULL,
  `COD_CIDADESGOIANIA` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`CID_ID`),
  KEY `akCidade1` (`EST_SIGLA`,`NOME_CIDADE`),
  KEY `akCidade2` (`COD_IBGE`),
  KEY `akCidade3` (`COD_SIAFI`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=5571 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `classificacaocliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classificacaocliente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLA_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CLA_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CLA_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `ATI_ID` varchar(20) NOT NULL DEFAULT '',
  `PES_IDVENDEDOR` varchar(20) NOT NULL DEFAULT '',
  `CLI_SIMPLESESTADUAL` char(1) NOT NULL DEFAULT '',
  `CLI_MEDIAATRASO` int(11) DEFAULT NULL,
  `CLI_VALORMAIORACUMULO` double(18,8) DEFAULT NULL,
  `CLI_VALORMAIORFATURA` double(18,8) DEFAULT NULL,
  `CLI_VALORULTIMACOMPRA` double(18,8) DEFAULT NULL,
  `CLI_VALORCOMPRASANO` double(18,8) DEFAULT NULL,
  `CLI_VALORPENDENTE` double(18,8) DEFAULT NULL,
  `CLI_DATAPRIMEIRACOMPRA` datetime DEFAULT NULL,
  `CLI_DATAULTIMACOMPRA` datetime DEFAULT NULL,
  `CLI_DATAMAIORACUMULO` datetime DEFAULT NULL,
  `CLI_DATAMAIORFATURA` datetime DEFAULT NULL,
  `CLI_PERCMARGEMLUCRO` double(18,8) NOT NULL,
  `VEN_PERCCOMISSAO` double(18,8) NOT NULL,
  `PCO_ID` int(11) NOT NULL DEFAULT '0',
  `CLI_TIPO` varchar(20) DEFAULT NULL,
  `CLI_VALORPRIMEIRACOMPRA` double(18,8) DEFAULT NULL,
  `CLI_DATAPRIMEIRAFATURA` datetime DEFAULT NULL,
  `CLI_DATAULTIMAFATURA` datetime DEFAULT NULL,
  `CLI_DATAMAIORCOMPRA` datetime DEFAULT NULL,
  `CLI_VALORPRIMEIRAFATURA` double(18,8) DEFAULT NULL,
  `CLI_VALORULTIMAFATURA` double(18,8) DEFAULT NULL,
  `CLI_VALORMAIORCOMPRA` double(18,8) DEFAULT NULL,
  `CLI_LIMITARCREDITOCOMPRA` char(1) DEFAULT NULL,
  `CLI_LIMITECREDITOCOMPRA` double(18,8) DEFAULT NULL,
  `CLI_LIMITARPERCATRASOPERMITIDO` char(1) DEFAULT NULL,
  `CLI_LIMITEPERCATRASO` double(18,8) DEFAULT NULL,
  `PES_IDAGENCIA` varchar(20) DEFAULT NULL,
  `CLI_SUBSTITUTOTRIBUTARIO` char(1) DEFAULT NULL,
  `CLI_ISSRETIDONFSE` char(1) DEFAULT NULL,
  `TIPOCOMPROVANTENFE` varchar(20) NOT NULL,
  `CLI_TIPOTRIBUTACAO` varchar(20) DEFAULT NULL,
  `CLI_LIQUIDACAODUVIDOSA` char(1) DEFAULT 'N',
  `CLI_VALIDADEANALISECREDITO` datetime DEFAULT NULL,
  `CLI_HABILITARPERCDESCONTO` char(1) DEFAULT NULL,
  `CLI_PERCDESCONTOMINIMO` double(18,8) DEFAULT NULL,
  `CLI_PERCDESCONTOMAXIMO` double(18,8) DEFAULT NULL,
  `PCO_IDATIVO` int(11) NOT NULL DEFAULT '0',
  `CLI_CODIGOCARTEIRA` varchar(10) DEFAULT NULL,
  `NAOGERARCOBRANCA` char(1) DEFAULT NULL,
  `CLI_CONSUMIDORFINAL` char(1) DEFAULT NULL,
  `CLI_UTILIZARCODBARRASPRODDANFE` char(1) DEFAULT NULL,
  `CLI_VERIFICARVALIDADECOMPRA` char(1) DEFAULT 'S',
  `IDSALESFORCE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkAtividade` (`EMP_ID`,`ATI_ID`),
  KEY `fkVendedor` (`EMP_ID`,`PES_IDVENDEDOR`),
  KEY `fkPlanoConta` (`EMP_ID`,`PCO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `clientecnae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientecnae` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `CNA_CODIGO` varchar(10) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`CNA_CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`PES_ID`),
  KEY `fkCNAE` (`EMP_ID`,`CNA_CODIGO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `clienteporgrupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clienteporgrupo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `GRC_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`GRC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`PES_ID`),
  KEY `fkGrupoCliente` (`EMP_ID`,`GRC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cnae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cnae` (
  `CNA_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CNA_SECAO` varchar(1) NOT NULL DEFAULT '0',
  `CNA_NIVELCOD` int(10) unsigned NOT NULL DEFAULT '0',
  `CNA_PAICOD` varchar(10) DEFAULT NULL,
  `CNA_CODIGO` varchar(10) DEFAULT NULL,
  `CNA_DESCRICAO` varchar(200) NOT NULL DEFAULT '0',
  `CNA_VISIVEL` varchar(1) NOT NULL DEFAULT 'S',
  `DESATIVADA` char(1) DEFAULT NULL,
  `IDCNAE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`CNA_ID`),
  KEY `akCNAE1` (`CNA_SECAO`),
  KEY `akCNAE2` (`CNA_NIVELCOD`),
  KEY `akCNAE3` (`CNA_PAICOD`),
  KEY `akCNAE4` (`CNA_CODIGO`),
  KEY `akCNAE5` (`CNA_DESCRICAO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=2429 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cnae_ncm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cnae_ncm` (
  `CCN_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CCN_CNAE_COD` varchar(10) NOT NULL DEFAULT '0',
  `CCN_NCM_COD` varchar(10) NOT NULL DEFAULT '0',
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`CCN_ID`),
  UNIQUE KEY `akCNAENCM1` (`CCN_CNAE_COD`,`CCN_NCM_COD`),
  KEY `fkCNAE` (`CCN_CNAE_COD`),
  KEY `fkNCM` (`CCN_NCM_COD`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=12334 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `codigoatividadeprestservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigoatividadeprestservico` (
  `CAPS_ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAPS_CODIGO` varchar(15) NOT NULL DEFAULT '0.000',
  `CAPS_DESC` varchar(200) NOT NULL DEFAULT '',
  `CAPS_TRIB` varchar(20) DEFAULT '',
  PRIMARY KEY (`CAPS_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `comissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comissao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDCOMISSAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DOC_ID` int(10) DEFAULT NULL,
  `CLASSIFICACAO` int(10) DEFAULT NULL,
  `SEQUENCIALITEM` int(10) DEFAULT NULL,
  `TIPOLANCAMENTO` varchar(20) NOT NULL,
  `DATALANCAMENTO` date NOT NULL,
  `DATAEMISSAO` date NOT NULL,
  `DATAVENCIMENTO` date NOT NULL,
  `NUMEROTITULO` varchar(20) NOT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL,
  `CODIGOHISTORICO` varchar(20) DEFAULT NULL,
  `DESCRICAOHISTORICO` varchar(100) NOT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL,
  `ULTIMOCODIGOUSUARIO` int(11) NOT NULL,
  `OBSERVACOES` varchar(500) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL,
  `BASECALCULOCOMISSAO` double(18,8) NOT NULL,
  `PERCCOMISS` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `SALDO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`IDCOMISSAO`),
  KEY `fkDocVencimentos` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`,`SEQUENCIALITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `comissaoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comissaoitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDCOMISSAO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAVENCIMENTO` date NOT NULL,
  `DATAEFETIVACAO` date NOT NULL,
  `DATABAIXA` date DEFAULT NULL,
  `CHAVECONTASPAGAR` int(11) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL,
  `ULTIMOCODIGOUSUARIO` int(11) NOT NULL,
  `OBSERVACOES` varchar(500) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL,
  `BASECALCULOSALDO` double(18,8) NOT NULL,
  `BASECALCULOCOMISSAO` double(18,8) NOT NULL,
  `PERCCOMISS` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `BAIXADO` char(1) NOT NULL,
  `CHAVERECEBERPAI` int(11) DEFAULT NULL,
  `CHAVEBAIXARECEBERPAI` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`IDCOMISSAO`,`SEQUENCIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `compromisso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compromisso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `COM_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `COM_DATAINICIO` date NOT NULL DEFAULT '0000-00-00',
  `COM_LOCAL` varchar(80) NOT NULL DEFAULT '',
  `COM_HORAINICIO` time NOT NULL DEFAULT '00:00:00',
  `COM_DATAFIM` date NOT NULL DEFAULT '0000-00-00',
  `COM_HORAFIM` time NOT NULL DEFAULT '00:00:00',
  `COM_DURACAO` varchar(25) NOT NULL,
  `COM_STATUS` varchar(20) NOT NULL DEFAULT '',
  `COM_ANOTACOES` longtext,
  `COM_ASSUNTO` varchar(100) DEFAULT '',
  `CODIGOUSUARIOLOGADO` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`COM_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `compromissoenvolvido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compromissoenvolvido` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `COM_ID` int(11) NOT NULL DEFAULT '0',
  `COE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `COE_EMPRESA` varchar(100) NOT NULL DEFAULT '',
  `COE_NOME` varchar(100) NOT NULL DEFAULT '',
  `COE_EMAIL` varchar(80) DEFAULT '',
  `COE_TELEFONE` varchar(12) DEFAULT '',
  `COE_TIPO` varchar(50) DEFAULT '',
  `COE_IDPESSOA` int(10) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`COM_ID`,`COE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCompromissoEnvolvido` (`EMP_ID`,`COM_ID`),
  KEY `fkEnvolvido` (`EMP_ID`,`COE_IDPESSOA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `compromissorecurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compromissorecurso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `COR_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `COR_DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `COR_TIPO` varchar(14) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`COR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `condutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `condutor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`) USING BTREE,
  KEY `fkEmpresa` (`EMP_ID`) USING BTREE,
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`) USING BTREE,
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contabancaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contabancaria` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `NUMEROCONTA` varchar(11) NOT NULL DEFAULT '0',
  `CODIGOBANCO` varchar(20) NOT NULL DEFAULT '',
  `INCLUIRFLUXOCAIXA` char(1) NOT NULL DEFAULT '',
  `NROULTIMOCHEQUE` int(11) NOT NULL DEFAULT '0',
  `CODIGOREDUZIDOCONTA` int(11) NOT NULL DEFAULT '0',
  `DIGITOCONTA` varchar(5) NOT NULL DEFAULT '0',
  `DESATIVADA` varchar(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkBanco` (`EMP_ID`,`CODIGOBANCO`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOREDUZIDOCONTA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contabancariausu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contabancariausu` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_CONTAB` varchar(20) NOT NULL DEFAULT '',
  `ID_USU` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_CONTAB`,`ID_USU`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkContaBancaria` (`EMP_ID`,`ID_CONTAB`),
  KEY `fkUsuario` (`ID_USU`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contaemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contaemail` (
  `CE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CE_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CE_IDSERVIDOR` int(11) DEFAULT NULL,
  `CE_USUARIO` varchar(100) DEFAULT NULL,
  `CE_SENHAUSUARIO` varchar(120) DEFAULT NULL,
  `CE_EMAIL` varchar(100) NOT NULL DEFAULT '',
  `CE_TIPOENVIOEMAIL` varchar(20) NOT NULL DEFAULT '',
  `CE_UTILIZARASSINATURA` char(1) NOT NULL DEFAULT '',
  `CE_ASSINATURA` longtext,
  `CE_DESATIVADO` char(1) NOT NULL,
  `CE_LOCALEXECUTAVELMSOUTLOOK` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`CE_ID`),
  KEY `fkContaEmailServidor` (`CE_IDSERVIDOR`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contaemailservidor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contaemailservidor` (
  `CES_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CES_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CES_SERVIDORSMTP` varchar(50) DEFAULT NULL,
  `CES_REQUERSSL` char(1) DEFAULT '',
  `CES_PORTA` int(11) DEFAULT NULL,
  `CES_REQUERAUTENTICACAO` char(1) NOT NULL,
  `CES_TIPOSSL` varchar(50) NOT NULL,
  `CES_VERSAOSSL` varchar(50) NOT NULL,
  PRIMARY KEY (`CES_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contagemlote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contagemlote` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_CONTLOTE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DT_ABERTURA` datetime DEFAULT NULL,
  `DT_CONFERENCIA` datetime DEFAULT NULL,
  `NOMEUSUARIO` varchar(30) DEFAULT NULL,
  `SITUACAO` varchar(30) DEFAULT NULL,
  `DT_EFETIVACAO` datetime DEFAULT NULL,
  `OBSERVACAO` longtext,
  PRIMARY KEY (`EMP_ID`,`ID_CONTLOTE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contagemloteitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contagemloteitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOTE` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMITEM` varchar(30) NOT NULL,
  `CODIGOITEM` varchar(20) NOT NULL,
  `DESCRICAOITEM` varchar(100) NOT NULL,
  `MOVIMENTARVALORMEDIO` char(1) NOT NULL DEFAULT 'N',
  `VALORUNITARIO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `DT_CONTAGEM` datetime NOT NULL,
  `NOMEUSUARIO` varchar(30) NOT NULL,
  `QTDELANCADA` double(18,8) NOT NULL,
  `QTDEESTOQUE` double(18,8) NOT NULL,
  `EFETIVADO` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_LOTE`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkInventario` (`EMP_ID`,`ID_LOTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contato` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `CON_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CON_NOME` varchar(50) NOT NULL DEFAULT '',
  `CON_FONE1` varchar(12) DEFAULT NULL,
  `CON_FONE2` varchar(12) DEFAULT NULL,
  `CON_FAX` varchar(12) DEFAULT NULL,
  `CON_RAMAL` varchar(5) DEFAULT NULL,
  `CON_DEPARTAMENTO` varchar(50) DEFAULT NULL,
  `CON_HOMEPAGE` varchar(50) DEFAULT NULL,
  `CON_EMAIL` varchar(100) DEFAULT NULL,
  `CON_DTANIVERSARIO` datetime DEFAULT NULL,
  `CON_RG` varchar(20) DEFAULT NULL,
  `CON_CPF` varchar(14) DEFAULT NULL,
  `CON_MSN` varchar(50) DEFAULT NULL,
  `CON_SKYPE` varchar(50) DEFAULT NULL,
  `CON_SEXO` varchar(20) DEFAULT NULL,
  `END_ID` int(11) DEFAULT '0',
  `VEN_ID` varchar(20) DEFAULT NULL,
  `CODIGOCARGO` int(11) DEFAULT NULL,
  `VEN_PERC` double(18,8) DEFAULT NULL,
  `CON_PERMITIRENVIAREMAIL` char(1) DEFAULT NULL,
  `IDSALESFORCE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`CON_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkDepto` (`CON_DEPARTAMENTO`),
  KEY `fkEndereco` (`EMP_ID`,`PES_ID`,`END_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkCargo` (`EMP_ID`,`CODIGOCARGO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contatocargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contatocargo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contratofor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contratofor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORIGEM` varchar(30) NOT NULL DEFAULT '',
  `NUMEROCONTRATO` varchar(30) NOT NULL DEFAULT '',
  `IDORIGEM` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA` datetime DEFAULT NULL,
  `DATAVENCIMENTO` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORIGEM`,`NUMEROCONTRATO`,`IDORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `correlacaochaves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `correlacaochaves` (
  `ID_CORRELACAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) DEFAULT '0',
  `NOMETABELA` varchar(100) NOT NULL DEFAULT '0',
  `ID_EXTERNO` varchar(50) NOT NULL,
  `ID_WINGRAPH` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_CORRELACAO`),
  KEY `akIdWingraph` (`NOMETABELA`,`ID_WINGRAPH`),
  KEY `akIdExterno` (`NOMETABELA`,`ID_EXTERNO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmanotacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmanotacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CAN_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAN_IDUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CAN_IDCLIENTE` varchar(30) NOT NULL,
  `CAN_DATA_REGISTRO` datetime NOT NULL,
  `CAN_ASSUNTO` varchar(100) DEFAULT NULL,
  `CAN_DETALHAMENTO` longtext,
  `CAN_CATEGORIA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CAN_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CAN_IDUSUARIO`),
  KEY `fkCliente` (`EMP_ID`,`CAN_IDCLIENTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmatendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmatendimento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CRA_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EVE_ID` int(11) NOT NULL DEFAULT '0',
  `CRA_TIPO` int(11) DEFAULT NULL,
  `CRA_IDCLIENTE` varchar(30) NOT NULL,
  `CRA_CONTATO` varchar(100) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CRA_ID`),
  KEY `akCRMAtendimento1` (`EVE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEvento` (`EMP_ID`,`EVE_ID`),
  KEY `fkCliente` (`EMP_ID`,`CRA_IDCLIENTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmevento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmevento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `EVE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EVE_CATEGORIA` int(11) DEFAULT NULL,
  `EVE_DATA_REGISTRO` datetime NOT NULL,
  `EVE_ASSUNTO` varchar(100) DEFAULT '',
  `EVE_DETALHAMENTO` longtext,
  `EVE_TIPO` varchar(100) NOT NULL,
  `EVE_LISTAATUAL` int(10) DEFAULT NULL,
  `CODIGOUSUARIOLOGADO` int(10) DEFAULT NULL,
  `DATA_RETORNO` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`EVE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkLista` (`EMP_ID`,`EVE_LISTAATUAL`),
  KEY `fkUsuario` (`CODIGOUSUARIOLOGADO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmeventoetapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmeventoetapa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `EET_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EET_EVE_ID` int(11) NOT NULL DEFAULT '0',
  `EET_IDLISTA` int(11) NOT NULL DEFAULT '0',
  `EET_DATA` datetime NOT NULL,
  `EET_IDUSUARIOORIGEM` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`EET_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEvento` (`EMP_ID`,`EET_EVE_ID`),
  KEY `fkLista` (`EMP_ID`,`EET_IDLISTA`),
  KEY `fkUsuario` (`EET_IDUSUARIOORIGEM`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmnotificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmnotificacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CRN_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CRN_TIPO` varchar(100) NOT NULL DEFAULT '',
  `CRN_IDUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CRN_DATA_LEITURA` datetime NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CRN_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CRN_IDUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmocorrencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmocorrencia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CRO_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CRO_CRTID` int(11) NOT NULL DEFAULT '0',
  `CRO_IDUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CRO_DATA_REGISTRO` datetime NOT NULL,
  `CRO_DETALHAMENTO` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CRO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTarefa` (`EMP_ID`,`CRO_CRTID`),
  KEY `fkUsuario` (`CRO_IDUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmpesquisasatisfacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmpesquisasatisfacao` (
  `IDPESQSATISFACAO` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(10) DEFAULT NULL,
  `CLASSIFICACAO` int(10) DEFAULT NULL,
  `DOC_ID` int(10) DEFAULT NULL,
  `ORS_ID` varchar(30) DEFAULT NULL,
  `ID_CAMPANHA` int(11) DEFAULT NULL,
  `IDPERFILSATISFACAO` int(11) NOT NULL DEFAULT '0',
  `DATAORIGEM` date NOT NULL,
  `DATADISPARO` date NOT NULL,
  `CLI_ID` varchar(30) NOT NULL,
  `CON_ID` int(11) NOT NULL,
  PRIMARY KEY (`IDPESQSATISFACAO`),
  KEY `fkDocumento` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkPerfilSatisfacao` (`EMP_ID`,`IDPERFILSATISFACAO`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkCampanha` (`EMP_ID`,`ID_CAMPANHA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `crmtarefa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crmtarefa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CRT_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EVE_ID` int(11) NOT NULL DEFAULT '0',
  `CRT_STATUS` varchar(100) NOT NULL DEFAULT '',
  `CRT_IDUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CRT_DATA_PREVISAO` datetime NOT NULL,
  `CRT_PRIORIDADE` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CRT_ID`),
  KEY `akCRMTarefa1` (`EVE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEvento` (`EMP_ID`,`EVE_ID`),
  KEY `fkUsuario` (`CRT_IDUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `damdfe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damdfe` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDFE_TPEMIS` varchar(30) NOT NULL,
  `MDFE_TPAMB` varchar(30) NOT NULL,
  `MDFE_NUMERO` int(10) unsigned NOT NULL,
  `MDFE_NUMEROSERIE` varchar(20) NOT NULL,
  `MDFE_CHAVEACESSO` varchar(44) NOT NULL,
  `MDFE_PROTOCOLO` varchar(15) NOT NULL,
  `MDFE_DHRECBTO` datetime DEFAULT NULL,
  `MDFE_DATAEMISSAO` datetime NOT NULL,
  `MDFE_DATAINICIOVIAGEM` datetime DEFAULT NULL,
  `MDFE_UFCARREGAMENTO` char(2) NOT NULL DEFAULT '',
  `MDFE_UFDESCARREGAMENTO` char(2) NOT NULL DEFAULT '',
  `EMI_CPFCNPJ` varchar(14) NOT NULL,
  `EMI_RAZSOC` varchar(60) NOT NULL,
  `EMI_NOMEFANTASIA` varchar(40) NOT NULL,
  `EMI_LOGRADOURO` varchar(100) DEFAULT NULL,
  `EMI_NUMERO` varchar(10) DEFAULT NULL,
  `EMI_COMPLEMENTO` varchar(25) DEFAULT NULL,
  `EMI_BAIRRO` varchar(20) DEFAULT NULL,
  `EMI_CIDADE` varchar(30) DEFAULT NULL,
  `EMI_UF` char(2) DEFAULT NULL,
  `EMI_CEP` varchar(8) DEFAULT NULL,
  `EMI_FONE` varchar(12) DEFAULT NULL,
  `EMI_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `EMI_RNTRC` varchar(15) DEFAULT NULL,
  `TOT_QTDETOTALCTE` int(11) NOT NULL,
  `TOT_QTDETOTALNFE` int(11) NOT NULL,
  `TOT_PESOBRUTOTOTALCARGA` double(18,8) DEFAULT NULL,
  `MDFE_INFORMACOESADICIONAIS` longtext,
  `MDFE_INFORMACOESCOMPLEMENTARES` longtext,
  `MDFE_CHAVEACESSOCONTIGENCIA` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_damdfee_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_damdfe_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `damdfecondutores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damdfecondutores` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDDAMDFE` int(11) NOT NULL,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDFECOND_CONDUTORNOME` varchar(100) DEFAULT NULL,
  `MDFECOND_CONDUTORCPF` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_damdfecondutores_damdfe_idx` (`IDDAMDFE`) USING BTREE,
  CONSTRAINT `fk_damdfecondutores_damdfe1` FOREIGN KEY (`IDDAMDFE`) REFERENCES `damdfe` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `damdfedocumentosfiscais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damdfedocumentosfiscais` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDDAMDFE` int(11) NOT NULL,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDFEDOC_MODELODOC` varchar(10) DEFAULT NULL,
  `MDFEDOC_CHAVEACESSO` varchar(44) DEFAULT NULL,
  `MDFEDOC_IDTIPOUNTRANSPORTE` int(11) DEFAULT NULL,
  `UNCARGA_IDTIPOUNCARGA` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_damdfedocumentosfiscais_damdfe_idx` (`IDDAMDFE`) USING BTREE,
  CONSTRAINT `fk_damdfedocumentosfiscais_damdfe1` FOREIGN KEY (`IDDAMDFE`) REFERENCES `damdfe` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `damdfevalepedagio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damdfevalepedagio` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDDAMDFE` int(11) NOT NULL,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDFEVPED_CPFCNPJFORNECEDOR` varchar(15) DEFAULT NULL,
  `MDFEVPED_CPFCNPJRESPONSAVAELPAGTO` varchar(15) DEFAULT NULL,
  `MDFEVPED_NUMCOMPROVANTECOMPRA` varchar(20) DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_damdfevalepedagio_damdfe_idx` (`IDDAMDFE`) USING BTREE,
  CONSTRAINT `fk_damdfevalepedagio_damdfe1` FOREIGN KEY (`IDDAMDFE`) REFERENCES `damdfe` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `damdfeveiculos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damdfeveiculos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDDAMDFE` int(11) NOT NULL,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDFEVEIC_REBOQUE` char(1) DEFAULT NULL,
  `MDFEVEIC_IDVEICULO` int(11) DEFAULT NULL,
  `MDFEVEIC_PLACA` varchar(7) DEFAULT NULL,
  `MDFEVEIC_RNTRC` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_damdfeveiculos_damdfe_idx` (`IDDAMDFE`) USING BTREE,
  CONSTRAINT `fk_damdfeveiculos_damdfe1` FOREIGN KEY (`IDDAMDFE`) REFERENCES `damdfe` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfce` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NFCE_NUMERO` int(10) unsigned NOT NULL,
  `NFCE_NUMEROSERIE` varchar(20) NOT NULL,
  `NFCE_CHAVEACESSO` varchar(44) NOT NULL,
  `NFCE_PROTOCOLO` varchar(15) NOT NULL,
  `NFCE_OPERACAO` char(1) NOT NULL,
  `NFCE_DATAEMISSAO` datetime NOT NULL,
  `NFCE_DATAENTRADASAIDA` datetime DEFAULT NULL,
  `EMI_CPFCNPJ` varchar(14) NOT NULL,
  `EMI_RAZSOC` varchar(60) NOT NULL,
  `EMI_NOMEFANTASIA` varchar(40) NOT NULL,
  `EMI_LOGRADOURO` varchar(100) DEFAULT NULL,
  `EMI_NUMERO` varchar(10) DEFAULT NULL,
  `EMI_COMPLEMENTO` varchar(25) DEFAULT NULL,
  `EMI_BAIRRO` varchar(20) DEFAULT NULL,
  `EMI_CIDADE` varchar(30) DEFAULT NULL,
  `EMI_UF` char(2) DEFAULT NULL,
  `EMI_CEP` varchar(8) DEFAULT NULL,
  `EMI_FONE` varchar(12) DEFAULT NULL,
  `EMI_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `DES_CODIGOPESSOA` varchar(20) NOT NULL,
  `DES_CPFCNPJ` varchar(14) DEFAULT NULL,
  `DES_RAZSOC` varchar(100) DEFAULT NULL,
  `DES_CODIGOENDERECO` int(10) unsigned DEFAULT NULL,
  `DES_LOGRADOURO` varchar(100) DEFAULT NULL,
  `DES_NUMERO` varchar(6) DEFAULT NULL,
  `DES_COMPLEMENTO` varchar(30) DEFAULT NULL,
  `DES_BAIRRO` varchar(30) DEFAULT NULL,
  `DES_CIDADE` varchar(30) DEFAULT NULL,
  `DES_UF` char(2) DEFAULT NULL,
  `DES_CEP` varchar(8) DEFAULT NULL,
  `DES_FONE` varchar(12) DEFAULT NULL,
  `DES_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `TOT_TOTALBRUTOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSTOTALIQUIDOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ISSVALORTOTALSERVICOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ISSBASE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ISSVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_DESCONTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `INF_ADICCOMPLEMENTAR` longtext,
  `INF_MSGFISCAL` longtext,
  `INF_SEFAZ` longtext,
  `NFCE_TPEMIS` varchar(30) NOT NULL,
  `NFCE_INDPAG` varchar(30) NOT NULL,
  `NFCE_TPAMB` varchar(30) NOT NULL,
  `NFCE_DHRECBTO` datetime DEFAULT NULL,
  `NFCE_CHAVEACESSOCONTIGENCIA` varchar(50) DEFAULT NULL,
  `TOT_PRODUTOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EMI_INSMUNICIPAL` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`DES_CODIGOPESSOA`),
  KEY `fkEnderecoDest` (`EMP_ID`,`DES_CODIGOPESSOA`,`DES_CODIGOENDERECO`),
  KEY `fkFormaPagto` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfceitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfceitem` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(20) NOT NULL,
  `CODIGO` varchar(20) NOT NULL,
  `DESCRICAO` varchar(200) NOT NULL,
  `UNIDADE` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORUNITARIO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORDESCONTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORTOTAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfcepagamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfcepagamentos` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FORMAPAGTO` varchar(20) NOT NULL,
  `VENCIMENTO` date NOT NULL,
  `VALOR` double(18,8) unsigned NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfe` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NFE_NUMERO` int(10) unsigned NOT NULL,
  `NFE_NUMEROSERIE` varchar(20) NOT NULL,
  `NFE_CHAVEACESSO` varchar(44) NOT NULL,
  `NFE_PROTOCOLO` varchar(15) NOT NULL,
  `NFE_OPERACAO` char(1) NOT NULL,
  `NFE_NATUREZAOPERACAOCODIGO` varchar(20) DEFAULT NULL,
  `NFE_NATUREZAOPERACAODESC` varchar(200) DEFAULT NULL,
  `NFE_DATAEMISSAO` datetime NOT NULL,
  `NFE_DATAENTRADASAIDA` datetime DEFAULT NULL,
  `EMI_CPFCNPJ` varchar(14) NOT NULL,
  `EMI_RAZSOC` varchar(60) NOT NULL,
  `EMI_NOMEFANTASIA` varchar(40) NOT NULL,
  `EMI_LOGRADOURO` varchar(100) DEFAULT NULL,
  `EMI_NUMERO` varchar(10) DEFAULT NULL,
  `EMI_COMPLEMENTO` varchar(25) DEFAULT NULL,
  `EMI_BAIRRO` varchar(20) DEFAULT NULL,
  `EMI_CIDADE` varchar(30) DEFAULT NULL,
  `EMI_UF` char(2) DEFAULT NULL,
  `EMI_CEP` varchar(8) DEFAULT NULL,
  `EMI_FONE` varchar(12) DEFAULT NULL,
  `EMI_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `DES_CODIGOPESSOA` varchar(20) NOT NULL,
  `DES_CPFCNPJ` varchar(14) DEFAULT NULL,
  `DES_RAZSOC` varchar(100) DEFAULT NULL,
  `DES_CODIGOENDERECO` int(10) unsigned DEFAULT NULL,
  `DES_LOGRADOURO` varchar(100) DEFAULT NULL,
  `DES_NUMERO` varchar(6) DEFAULT NULL,
  `DES_COMPLEMENTO` varchar(30) DEFAULT NULL,
  `DES_BAIRRO` varchar(30) DEFAULT NULL,
  `DES_CIDADE` varchar(30) DEFAULT NULL,
  `DES_UF` char(2) DEFAULT NULL,
  `DES_CEP` varchar(8) DEFAULT NULL,
  `DES_FONE` varchar(12) DEFAULT NULL,
  `DES_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `FAT_FORMAPAGAMENTOCODIGO` varchar(20) DEFAULT NULL,
  `FAT_FORMAPAGAMENTODESC` varchar(50) DEFAULT NULL,
  `FAT_NUMERO` varchar(20) DEFAULT NULL,
  `FAT_VALORORIGINAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `FAT_VALORDESCONTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `FAT_VALORLIQUIDO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSBASE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSSTBASE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSSTVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSIPIVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSFRETEVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSSEGUROVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSDESCONTOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSOUTROSVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_TOTALBRUTOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ICMSTOTALIQUIDOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TRA_CODIGOPESSOA` varchar(20) DEFAULT NULL,
  `TRA_CPFCNPJ` varchar(14) DEFAULT NULL,
  `TRA_RAZSOC` varchar(100) DEFAULT NULL,
  `TRA_CODIGOENDERECO` int(10) unsigned DEFAULT NULL,
  `TRA_LOGRADOURO` varchar(100) DEFAULT NULL,
  `TRA_CIDADE` varchar(30) DEFAULT NULL,
  `TRA_UF` char(2) DEFAULT NULL,
  `TRA_INSCESTADUAL` varchar(20) DEFAULT NULL,
  `TRA_FRETEPORCONTA` char(1) DEFAULT NULL,
  `TRA_PLACAVEICULO` varchar(20) DEFAULT NULL,
  `TRA_UFVEICULO` char(2) DEFAULT NULL,
  `TRA_QUANTIDADE` double(18,8) unsigned NOT NULL DEFAULT '0.00000000',
  `TRA_ESPECIE` varchar(40) DEFAULT NULL,
  `TRA_PESOBRUTO` double(18,8) unsigned NOT NULL DEFAULT '0.00000000',
  `TRA_PESOLIQUIDO` double(18,8) unsigned NOT NULL DEFAULT '0.00000000',
  `TOT_ISSVALORTOTALSERVICOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ISSBASE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TOT_ISSVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `INF_ADICCOMPLEMENTAR` longtext,
  `INF_ADICFISCO` longtext,
  `NFE_TPEMIS` varchar(30) NOT NULL,
  `NFE_INDPAG` varchar(30) NOT NULL,
  `NFE_TPAMB` varchar(30) NOT NULL,
  `NFE_DHRECBTO` datetime DEFAULT NULL,
  `NFE_CHAVEACESSOCONTIGENCIA` varchar(50) DEFAULT NULL,
  `TOT_PRODUTOVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EMI_INSMUNICIPAL` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNatOP` (`EMP_ID`,`NFE_NATUREZAOPERACAOCODIGO`),
  KEY `fkCliente` (`EMP_ID`,`DES_CODIGOPESSOA`),
  KEY `fkEnderecoDest` (`EMP_ID`,`DES_CODIGOPESSOA`,`DES_CODIGOENDERECO`),
  KEY `fkFormaPagto` (`EMP_ID`,`FAT_FORMAPAGAMENTOCODIGO`),
  KEY `fkTransport` (`EMP_ID`,`TRA_CODIGOPESSOA`),
  KEY `fkEnderecoTransp` (`EMP_ID`,`TRA_CODIGOPESSOA`,`TRA_CODIGOENDERECO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfeitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfeitem` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(20) NOT NULL,
  `CODIGO` varchar(20) NOT NULL,
  `DESCRICAO` varchar(200) NOT NULL,
  `NCM` varchar(10) DEFAULT NULL,
  `CST` varchar(10) DEFAULT NULL,
  `CFOP` varchar(8) DEFAULT NULL,
  `UNIDADE` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORUNITARIO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORDESCONTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORTOTAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ICMSBASE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ICMSPERC` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ICMSVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `IPIPERC` double(18,8) NOT NULL DEFAULT '0.00000000',
  `IPIVALOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  `PISPERC` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `danfevencimentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danfevencimentos` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERODOC` varchar(20) NOT NULL,
  `VENCIMENTO` date NOT NULL,
  `VALOR` double(18,8) unsigned NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CODIGO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `descricaoautomaticaorc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `descricaoautomaticaorc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ATIVA` char(1) NOT NULL DEFAULT '',
  `DESCRICAO` longtext,
  `ATIVAFOLHA` char(1) NOT NULL DEFAULT '',
  `MOSTRARACABFOLHA` char(1) NOT NULL DEFAULT '',
  `MOSTRARSERVFOLHA` char(1) NOT NULL DEFAULT '',
  `DESCRICAOORCFOLHA` longtext,
  `DESCRICAOCOMPFOLHA` longtext,
  `DESCRICAOFOLHA` longtext,
  `ATIVABLOCO` char(1) NOT NULL DEFAULT '',
  `MOSTRARACABBLOCO` char(1) NOT NULL DEFAULT '',
  `MOSTRARSERVBLOCO` char(1) NOT NULL DEFAULT '',
  `DESCRICAOORCBLOCO` longtext,
  `DESCRICAOCOMPBLOCO` longtext,
  `DESCRICAOBLOCO` longtext,
  `ATIVALIVRO` char(1) NOT NULL DEFAULT '',
  `MOSTRARACABLIVRO` char(1) NOT NULL DEFAULT '',
  `MOSTRARSERVLIVRO` char(1) NOT NULL DEFAULT '',
  `DESCRICAOORCLIVRO` longtext,
  `DESCRICAOCOMPLIVRO` longtext,
  `DESCRICAOLIVRO` longtext,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `descricaoautomaticaorcflexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `descricaoautomaticaorcflexo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ATIVAR` char(1) NOT NULL DEFAULT '',
  `DESCRICAOORC` longtext,
  `DESCRICAOCOMP` longtext,
  `DESCRICAO` longtext,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `despachoencomendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `despachoencomendas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DESP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA_CADASTRO` datetime NOT NULL,
  `ORIGEMPRODUTOENVIO` varchar(20) DEFAULT NULL,
  `ID_PRODUTOENVIO` varchar(11) DEFAULT NULL,
  `SERIEPEDNF` varchar(20) DEFAULT NULL,
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `CON_ID` int(11) DEFAULT NULL,
  `CON_NOME` varchar(100) DEFAULT '',
  `END_ID` varchar(20) DEFAULT '',
  `ID_FORMADESPACHO` int(11) NOT NULL,
  `SERVICO_CORREIO` varchar(20) DEFAULT '',
  `SERVICO_CORREIO_ADICIONAL` varchar(20) DEFAULT '',
  `VALOR_DECLARADO` double(18,8) DEFAULT NULL,
  `CODIGO_RASTREIO` varchar(50) DEFAULT '',
  `SIGLA_TRIAGEM` varchar(10) DEFAULT '',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `STATUSOCORRENCIA` longtext,
  `ENVIADO_EMAIL` char(1) DEFAULT '',
  `DATA_ENVIOEMAIL` datetime DEFAULT NULL,
  `EMAIL_ENVIOEMAIL` varchar(30) DEFAULT '',
  `USUARIO_CADASTRO` varchar(30) NOT NULL DEFAULT '',
  `OCORRENCIAENVIOEMAIL` longtext,
  PRIMARY KEY (`EMP_ID`,`DESP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `difelementospub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `difelementospub` (
  `ELM_CODIGO` int(11) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ELM_CODIGO_DIF` int(11) unsigned NOT NULL,
  `ELM_DESCRICAO` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ELM_CODIGO`),
  UNIQUE KEY `ELM_CODIGO_DIF` (`ELM_CODIGO_DIF`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `difunmedida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `difunmedida` (
  `UNM_CODIGO` int(11) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UNM_CODIGO_DIF` int(11) unsigned NOT NULL,
  `UNM_ABREV` varchar(8) DEFAULT NULL,
  `UNM_DESCRICAO` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`UNM_CODIGO`),
  UNIQUE KEY `UNM_CODIGO_DIF` (`UNM_CODIGO_DIF`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `dispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispositivolegal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(30) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `doccomissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doccomissao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `ORIGEMREGISTRO` varchar(20) NOT NULL,
  `CODIGOVENDEDOR` varchar(20) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCCOMISSAO` double(18,8) NOT NULL,
  `VALORCOMISSAO` double(18,8) NOT NULL,
  `VALORORIGEMCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`ORIGEMREGISTRO`,`CODIGOVENDEDOR`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGOVENDEDOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `doccte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doccte` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `ID_CTE` varchar(30) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CLASSIFICACAO_CTE` int(10) unsigned DEFAULT NULL,
  `DOC_IDCTE` int(10) unsigned DEFAULT NULL,
  `CHAVENFEVINCULADA` varchar(44) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`ID_CTE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDocCte` (`EMP_ID`,`ID_CTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `docdispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docdispositivolegal` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `CODDISPLEGAL` varchar(30) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCDISPLEGAL` varchar(250) NOT NULL,
  `ORIGEMDISPLEGAL` varchar(20) NOT NULL,
  `CODIGOITEMORIGEM` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`CODDISPLEGAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDispLegal` (`EMP_ID`,`CODDISPLEGAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `docetiquetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docetiquetas` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `ETI_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTIPOEMBALAGEM` varchar(20) NOT NULL,
  `NUMERACAO` varchar(100) NOT NULL,
  `DESCRICAOETIQUETA` varchar(200) NOT NULL,
  `QUANTIDADEITEM` double NOT NULL,
  `QUANTIDADEPOREMBALAGEM` double NOT NULL,
  `QUANTIDADEETIQUETAS` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`ETI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEtiqueta` (`EMP_ID`,`ETI_ID`),
  KEY `fkTipoEmbalagem` (`EMP_ID`,`CODIGOTIPOEMBALAGEM`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `docmodelo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docmodelo` (
  `MOD_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MOD_COD` char(2) NOT NULL,
  `MOD_DESC` varchar(200) NOT NULL,
  PRIMARY KEY (`MOD_ID`),
  UNIQUE KEY `akDocModelo1` (`MOD_COD`),
  KEY `akDocModelo2` (`MOD_DESC`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoarquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoarquivos` (
  `EMP_ID` int(10) NOT NULL,
  `CLASSIFICACAO` int(10) NOT NULL,
  `DOC_ID` int(10) NOT NULL,
  `ID_ARQUIVO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`ID_ARQUIVO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentocabecalho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentocabecalho` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTIPODOC` varchar(20) NOT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `NUMERONF` int(11) DEFAULT NULL,
  `SERIENFFOR` varchar(20) DEFAULT NULL,
  `NUMERONFFOR` bigint(20) DEFAULT NULL,
  `DATAEMISSAO` datetime NOT NULL,
  `DATAENTREGA` datetime DEFAULT NULL,
  `DATAENTRADASAIDA` datetime DEFAULT NULL,
  `DATALANCAMENTO` datetime NOT NULL,
  `CODIGOFORMAPAGTO` varchar(20) NOT NULL,
  `PERCJUROS` double(18,8) NOT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL,
  `CODIGOENDERECOPESSOA` int(11) NOT NULL,
  `CODIGOCONTATOPESSOA` int(11) NOT NULL,
  `CODIGOVENDEDOR` varchar(20) DEFAULT NULL,
  `PERCCOMISSVENDEDOR` double(18,8) DEFAULT NULL,
  `CODIGOCARTEIRA` varchar(20) DEFAULT NULL,
  `CODIGOPERFILCOBRANCA` int(11) DEFAULT NULL,
  `NUMERODOCIMPORTACAO` varchar(20) DEFAULT NULL,
  `NUMEROCONFIRMACAO` varchar(20) DEFAULT NULL,
  `ORDEMCOMPRA` varchar(30) DEFAULT NULL,
  `CODIGOMODELO` char(3) DEFAULT NULL,
  `CANCELADA` char(1) DEFAULT NULL,
  `DDARECEBIDO` char(1) DEFAULT NULL,
  `BOLETORECEBIDO` char(1) DEFAULT NULL,
  `OBSERVACAO` longtext,
  `OBSERVACAOADICIONAL` longtext,
  `DOC_IDREFERENCIADO` int(11) DEFAULT NULL,
  `RETERISS` char(1) DEFAULT NULL,
  `TIPORETENCAOISS` varchar(20) DEFAULT NULL,
  `NUMERODOCUMENTO` varchar(20) DEFAULT NULL,
  `TIPODOCUMENTO` varchar(20) DEFAULT NULL,
  `TIPOMEIOPAGTO` varchar(20) DEFAULT NULL,
  `CODIGOPLANOCONTA` int(11) DEFAULT NULL,
  `CODIGOUSUARIOLOGADO` int(11) DEFAULT NULL,
  `NOMEUSUARIOLOGADO` varchar(30) DEFAULT NULL,
  `NUMEROCONSULTAINTERNA` varchar(20) DEFAULT NULL,
  `FATURADA` char(1) DEFAULT 'N',
  `IEST` varchar(20) DEFAULT NULL,
  `UFST` char(2) DEFAULT NULL,
  `STATUSPEDIDO` varchar(30) DEFAULT NULL,
  `ISSRETIDONFSE` char(1) DEFAULT NULL,
  `TIPOOPERACAORECOPI` varchar(32) DEFAULT NULL,
  `CHAVENFE` varchar(44) DEFAULT NULL,
  `NFEENVIADASEFAZ` char(1) DEFAULT NULL,
  `TIPONOTA` varchar(20) DEFAULT NULL,
  `PER_ID` int(11) DEFAULT NULL,
  `JUSTIFICATIVAAJUSTE` longtext,
  `JUSTIFICATIVACANCELAMENTO` longtext,
  `DOC_IDAJUSTE` int(11) DEFAULT NULL,
  `NUMEROCONTROLE` varchar(20) DEFAULT NULL,
  `NOMECONSUMIDOR` varchar(200) DEFAULT NULL,
  `EMAILCONSUMIDOR` varchar(100) DEFAULT NULL,
  `CPFCNPJCONSUMIDOR` varchar(30) DEFAULT NULL,
  `CPFCNPJINTERMEDIARIO` varchar(30) DEFAULT NULL,
  `DATACANCELAMENTO` datetime DEFAULT NULL,
  `SCM_ID` varchar(20) DEFAULT NULL,
  `DATALIBERACAO` date DEFAULT NULL,
  `CHAVENFEVINCULADA` varchar(44) DEFAULT NULL,
  `TIPOCTE` varchar(20) DEFAULT NULL,
  `RETERIR` char(1) DEFAULT NULL,
  `RETERCSLL` char(1) DEFAULT NULL,
  `RETEROUTRASRET` char(1) DEFAULT NULL,
  `RETERINSS` char(1) DEFAULT NULL,
  `RETERPIS` char(1) DEFAULT NULL,
  `RETERCOFINS` char(1) DEFAULT NULL,
  `PREFATURA` char(1) DEFAULT NULL,
  `CONSUMIDORFINAL` char(1) DEFAULT NULL,
  `DATAALTERACAOSTATUS` datetime DEFAULT NULL,
  `NOMEUSUARIOSTATUS` varchar(20) DEFAULT NULL,
  `INDICADORPRESENCA` int(11) DEFAULT NULL,
  `DESCRICAONFSE` longtext,
  `IDINTERMEDIADOR` varchar(20) DEFAULT NULL,
  `IDINSTITUICAOPAGAMENTO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoDoc` (`EMP_ID`,`CODIGOTIPODOC`),
  KEY `fkFormaPagto` (`EMP_ID`,`CODIGOFORMAPAGTO`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `fkEnderecoPessoa` (`EMP_ID`,`CODIGOPESSOA`,`CODIGOENDERECOPESSOA`),
  KEY `fkContatoPessoa` (`EMP_ID`,`CODIGOPESSOA`,`CODIGOCONTATOPESSOA`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGOVENDEDOR`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRA`),
  KEY `fkPerfilCobranca` (`EMP_ID`,`CODIGOPERFILCOBRANCA`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOPLANOCONTA`),
  KEY `fkUsuario` (`CODIGOUSUARIOLOGADO`),
  KEY `fkPerfilPreenc` (`EMP_ID`,`PER_ID`),
  KEY `fkStatusComanda` (`EMP_ID`,`SCM_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akSerieNumero` (`EMP_ID`,`SERIENF`,`NUMERONF`),
  KEY `fk_documentocabecalho_bandeiracartao` (`IDINSTITUICAOPAGAMENTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentocalculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentocalculo` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORTOTALCOMISSAO` double(18,8) DEFAULT NULL,
  `VALORTOTALFRETE` double(18,8) DEFAULT NULL,
  `VALORTOTALSEGURO` double(18,8) DEFAULT NULL,
  `PERCTOTALDESCONTO` double(18,8) DEFAULT NULL,
  `VALORTOTALDESCONTO` double(18,8) DEFAULT NULL,
  `VALORTOTALOUTROS` double(18,8) DEFAULT NULL,
  `VALORTOTALPRODUTOS` double(18,8) DEFAULT NULL,
  `VALORTOTALSERVICOS` double(18,8) DEFAULT NULL,
  `VALORTOTALBRUTO` double(18,8) DEFAULT NULL,
  `BASECALCULOICMS` double(18,8) DEFAULT NULL,
  `VALORTOTALICMS` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSST` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSST` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSDIF` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSDIF` double(18,8) DEFAULT NULL,
  `VALORTOTALIPI` double(18,8) DEFAULT NULL,
  `BASECALCULOPIS` double(18,8) DEFAULT NULL,
  `VALORTOTALPIS` double(18,8) DEFAULT NULL,
  `BASECALCULOCOFINS` double(18,8) DEFAULT NULL,
  `VALORTOTALCOFINS` double(18,8) DEFAULT NULL,
  `BASECALCULOISS` double(18,8) DEFAULT NULL,
  `VALORTOTALISS` double(18,8) DEFAULT NULL,
  `BASECALCULOINSS` double(18,8) DEFAULT NULL,
  `VALORTOTALINSS` double(18,8) DEFAULT NULL,
  `BASECALCULOIR` double(18,8) DEFAULT NULL,
  `VALORTOTALIR` double(18,8) DEFAULT NULL,
  `BASECALCULOCSLL` double(18,8) DEFAULT NULL,
  `VALORTOTALCSLL` double(18,8) DEFAULT NULL,
  `BASECALCULOOUTRASRETENCOES` double(18,8) DEFAULT NULL,
  `VALORTOTALOUTRASRETENCOES` double(18,8) DEFAULT NULL,
  `BASECALCULOCOFINSST` double(18,8) DEFAULT NULL,
  `BASECALCULOPISST` double(18,8) DEFAULT NULL,
  `VALORTOTALCOFINSST` double(18,8) DEFAULT NULL,
  `VALORTOTALPISST` double(18,8) DEFAULT NULL,
  `PERCTOTALACRESCIMO` double(18,8) DEFAULT NULL,
  `VALORTOTALACRESCIMO` double(18,8) DEFAULT NULL,
  `VALORTOTALLIQUIDO` double(18,8) DEFAULT NULL,
  `VALORTOTALFATURADO` double(18,8) DEFAULT NULL,
  `VALORTOTAL_IBPTFEDERAL` double(18,8) DEFAULT NULL,
  `PERCTOTAL_IBPTFEDERAL` double(18,8) DEFAULT NULL,
  `PERCTOTAL_IBPTESTADUAL` double(18,8) DEFAULT NULL,
  `VALORTOTAL_IBPTESTADUAL` double(18,8) DEFAULT NULL,
  `PERCTOTAL_IBPTMUNICIPAL` double(18,8) DEFAULT NULL,
  `VALORTOTAL_IBPTMUNICIPAL` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSDESONERADO` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSINTFCPUFDESTINO` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSINTUFDESTINO` double(18,8) DEFAULT NULL,
  `VALORTOTALCREDITOICMS` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSINTUFORIGEM` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSFCP` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSFCP` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSSTFCP` double(18,8) DEFAULT NULL,
  `VALORTOTALICMSSTFCP` double(18,8) DEFAULT NULL,
  `VALORTOTALIPIDEVOLVIDO` double(18,8) DEFAULT NULL,
  `VALORTOTALIMPOSTOIMPORTACAO` double(18,8) DEFAULT NULL,
  `VALORTOTALIOFIMPORTACAO` double(18,8) DEFAULT NULL,
  `VALORTOTALDESPESASADUANEIRAS` double(18,8) DEFAULT NULL,
  `VALORTOTALDESCONTOBENEFICIOS` double(18,8) DEFAULT NULL,
  `VALORTOTALCOFINSBENEF` double(18,8) DEFAULT NULL,
  `VALORTOTALPISBENEF` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitem` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMITEM` varchar(20) DEFAULT NULL,
  `DESCRICAOITEM` varchar(1000) NOT NULL,
  `CSTICMS` varchar(3) DEFAULT NULL,
  `CSTSERVICO` varchar(3) DEFAULT NULL,
  `CSTIPI` varchar(3) DEFAULT NULL,
  `CSTPIS` varchar(3) DEFAULT NULL,
  `CSTCOFINS` varchar(3) DEFAULT NULL,
  `CNAE` varchar(10) DEFAULT NULL,
  `CODIGOATIVIDADE` varchar(15) DEFAULT NULL,
  `CODIGOTRIBUTACAONFSE` varchar(20) DEFAULT NULL,
  `NCM` varchar(10) DEFAULT NULL,
  `CLASSIFICACAOFISCAL` varchar(10) DEFAULT NULL,
  `VALORUNITARIO` double(18,8) DEFAULT NULL,
  `VALORUNITARIOBASE` double(18,8) DEFAULT NULL,
  `UNIDADEMEDIDA` varchar(20) DEFAULT NULL,
  `UNIDADETRIBUTACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) DEFAULT NULL,
  `QUANTIDADETRIBUTACAO` double(18,8) DEFAULT NULL,
  `CFOP` varchar(20) DEFAULT NULL,
  `CODIGOPAPEL` varchar(20) DEFAULT NULL,
  `CODIGOTINTA` varchar(20) DEFAULT NULL,
  `CODIGOCHAPA` varchar(20) DEFAULT NULL,
  `CODIGOMATERIAL` varchar(20) DEFAULT NULL,
  `CODIGOITENSCOMPRA` varchar(20) DEFAULT NULL,
  `CODIGOORCAMENTO` varchar(20) DEFAULT NULL,
  `CODIGOORDEMPRODUCAO` varchar(20) DEFAULT NULL,
  `CODIGOITEMAUX` varchar(20) NOT NULL,
  `CODIGOPLANOCONTA` int(11) DEFAULT NULL,
  `CLASSIFICACAOITEM` varchar(20) DEFAULT NULL,
  `SALDO` double(18,8) DEFAULT NULL,
  `PESOUNITARIO` double(18,8) DEFAULT NULL,
  `PESOUNITARIOLIQUIDO` double(18,8) DEFAULT NULL,
  `SEQUENCIALREFERENCIADO` int(11) DEFAULT NULL,
  `PERCPRODSERV` double(18,8) DEFAULT NULL,
  `CODIGONATOPERACAO` varchar(20) DEFAULT NULL,
  `CODPEDCOMPRA` int(11) DEFAULT NULL,
  `CLASSPEDCOMPRA` int(11) DEFAULT NULL,
  `SEQPEDCOMPRA` int(11) DEFAULT NULL,
  `NUMEROPROPOSTAFAT` varchar(20) DEFAULT NULL,
  `SEQUENCIALITEMPROPOSTAFAT` int(11) DEFAULT NULL,
  `NUMEROPROPOSTAORC` varchar(20) DEFAULT NULL,
  `CODIGOLOTEFSC` varchar(40) DEFAULT NULL,
  `ID_EXPEDICAOPED` int(11) DEFAULT NULL,
  `FATORCONVERSAOUND` double(18,8) DEFAULT NULL,
  `NUMEROITEMORDEMCOMPRA` varchar(60) DEFAULT NULL,
  `CODIGOGRUPOORC` varchar(20) DEFAULT NULL,
  `REGRATRIBUTACAO` int(10) DEFAULT NULL,
  `NUMEROORDEMCOMPRA` varchar(20) DEFAULT NULL,
  `CODIGOFCI` varchar(50) DEFAULT NULL,
  `INFORMACOESADICITEM` longtext,
  `MOTIVODESONERACAOICMS` varchar(30) DEFAULT NULL,
  `CODIGOENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `CEST` varchar(10) DEFAULT NULL,
  `GEROUESTOQUE` char(1) DEFAULT NULL,
  `GEROUFATURAMENTO` char(1) DEFAULT NULL,
  `CODIGOPERFILCLASSIFICACAO` int(11) DEFAULT NULL,
  `RETERISS` char(1) DEFAULT NULL,
  `RETERINSS` char(1) DEFAULT NULL,
  `RETERIR` char(1) DEFAULT NULL,
  `RETERCSLL` char(1) DEFAULT NULL,
  `RETEROUTRASRET` char(1) DEFAULT NULL,
  `RETERPIS` char(1) DEFAULT NULL,
  `RETERCOFINS` char(1) DEFAULT NULL,
  `CODIGOPLANEJAMENTOOP` int(11) DEFAULT NULL,
  `INDICADORESTOQUE` int(11) DEFAULT NULL,
  `QUANTIDADECALC` double(18,8) DEFAULT NULL,
  `LARGURA` double(18,8) DEFAULT NULL,
  `ALTURA` double(18,8) DEFAULT NULL,
  `CODBENEFICIOFISCAL` varchar(20) DEFAULT NULL,
  `ZERARBASECALCPIS` char(1) DEFAULT 'N',
  `ZERARBASECALCCOFINS` char(1) DEFAULT 'N',
  `ZERARBASECALCICMS` char(1) DEFAULT 'N',
  `ZERARBASECALCIPI` char(1) DEFAULT 'N',
  `INCIDEDIFAL` char(1) DEFAULT NULL,
  `CODBENEFICIOFISCALPRESUMIDO` varchar(20) DEFAULT NULL,
  `CODBENEFICIOFISCALPRESUMIDORBC` varchar(20) DEFAULT NULL,
  `TIPOCALCULOPRESUMIDO` int(11) DEFAULT '1' COMMENT '1=Base de Cálculo do ICMS, 2=Valor do ICMS, 3=Valor Liquido, 4=Valor Bruto',
  `TIPOCALCULODIFERIMENTO` int(11) DEFAULT '1' COMMENT '1=Fora, 2=Dentro',
  `TIPOCALCULODESONERACAO` int(11) DEFAULT '1' COMMENT '1=Fora, 2=Dentro',
  `DEDUZIRDESONERACAOVLRNF` int(11) DEFAULT '1' COMMENT '0=Nao, 1=Sim',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPapel` (`EMP_ID`,`CODIGOPAPEL`),
  KEY `fkTinta` (`EMP_ID`,`CODIGOTINTA`),
  KEY `fkChapa` (`EMP_ID`,`CODIGOCHAPA`),
  KEY `fkMaterial` (`EMP_ID`,`CODIGOMATERIAL`),
  KEY `fkItensCompra` (`EMP_ID`,`CODIGOITENSCOMPRA`),
  KEY `fkOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkOP` (`EMP_ID`,`CODIGOORDEMPRODUCAO`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOPLANOCONTA`),
  KEY `fkNatOP` (`EMP_ID`,`CODIGONATOPERACAO`),
  KEY `fkLoteFSC` (`EMP_ID`,`CODIGOLOTEFSC`),
  KEY `fkExpedicaoPed` (`EMP_ID`,`ID_EXPEDICAOPED`),
  KEY `fkGrupoorcamento` (`EMP_ID`,`CODIGOGRUPOORC`),
  KEY `fkRegraTrib` (`EMP_ID`,`REGRATRIBUTACAO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akPedidoCompra` (`EMP_ID`,`CODPEDCOMPRA`,`CLASSPEDCOMPRA`,`SEQPEDCOMPRA`),
  KEY `akNCM` (`NCM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemcalculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemcalculo` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORBRUTO` double(18,8) DEFAULT NULL,
  `VALORLIQUIDO` double(18,8) DEFAULT NULL,
  `VALORFRETE` double(18,8) DEFAULT NULL,
  `PERCDESCONTO` double(18,8) DEFAULT NULL,
  `VALORDESCONTO` double(18,8) DEFAULT NULL,
  `VALORSEGURO` double(18,8) DEFAULT NULL,
  `PERCCOMISSAO` double(18,8) DEFAULT NULL,
  `VALORCOMISSAO` double(18,8) DEFAULT NULL,
  `PERCICMS` double(18,8) DEFAULT NULL,
  `VALORICMS` double(18,8) DEFAULT NULL,
  `BASECALCULOICMS` double(18,8) DEFAULT NULL,
  `PERCREDUCAOICMS` double(18,8) DEFAULT NULL,
  `PERCREDUCAOICMSST` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSST` double(18,8) DEFAULT NULL,
  `PERCICMSST` double(18,8) DEFAULT NULL,
  `VALORICMSST` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSDIF` double(18,8) DEFAULT NULL,
  `PERCICMSDIF` double(18,8) DEFAULT NULL,
  `VALORICMSDIF` double(18,8) DEFAULT NULL,
  `VALORICMSDEVIDO` double(18,8) DEFAULT NULL,
  `BASECALCULOIPI` double(18,8) DEFAULT NULL,
  `PERCIPI` double(18,8) DEFAULT NULL,
  `VALORIPI` double(18,8) DEFAULT NULL,
  `BASECALCULOPIS` double(18,8) DEFAULT NULL,
  `PERCPIS` double(18,8) DEFAULT NULL,
  `VALORPIS` double(18,8) DEFAULT NULL,
  `BASECALCULOPISST` double(18,8) DEFAULT NULL,
  `PERCPISST` double(18,8) DEFAULT NULL,
  `VALORPISST` double(18,8) DEFAULT NULL,
  `BASECALCULOCOFINS` double(18,8) DEFAULT NULL,
  `PERCCOFINS` double(18,8) DEFAULT NULL,
  `VALORCOFINS` double(18,8) DEFAULT NULL,
  `BASECALCULOCOFINSST` double(18,8) DEFAULT NULL,
  `PERCCOFINSST` double(18,8) DEFAULT NULL,
  `VALORCOFINSST` double(18,8) DEFAULT NULL,
  `BASECALCULOISS` double(18,8) DEFAULT NULL,
  `PERCREDUCAOISS` double(18,8) DEFAULT NULL,
  `VALORISS` double(18,8) DEFAULT NULL,
  `PERCISS` double(18,8) DEFAULT NULL,
  `BASECALCULOINSS` double(18,8) DEFAULT NULL,
  `VALORINSS` double(18,8) DEFAULT NULL,
  `PERCINSS` double(18,8) DEFAULT NULL,
  `BASECALCULOIR` double(18,8) DEFAULT NULL,
  `VALORIR` double(18,8) DEFAULT NULL,
  `PERCIR` double(18,8) DEFAULT NULL,
  `BASECALCULOCSLL` double(18,8) DEFAULT NULL,
  `VALORCSLL` double(18,8) DEFAULT NULL,
  `PERCCSLL` double(18,8) DEFAULT NULL,
  `BASECALCULOOUTRASRETENCOES` double(18,8) DEFAULT NULL,
  `VALOROUTRASRETENCOES` double(18,8) DEFAULT NULL,
  `PERCOUTRASRETENCOES` double(18,8) DEFAULT NULL,
  `PERCACRESCIMO` double(18,8) DEFAULT NULL,
  `VALORACRESCIMO` double(18,8) DEFAULT NULL,
  `VALORFATURADO` double(18,8) DEFAULT NULL,
  `VALORJUROS` double(18,8) DEFAULT NULL,
  `PERCJUROS` double(18,8) DEFAULT NULL,
  `VALOROUTROS` double(18,8) DEFAULT NULL,
  `PERCCREDITOICMS` double(18,8) DEFAULT NULL,
  `VALORCREDITOICMS` double(18,8) DEFAULT NULL,
  `PERCMVAICMSST` double(18,8) DEFAULT NULL,
  `PERC_IBPTFEDERAL` double(18,8) DEFAULT NULL,
  `VALOR_IBPTFEDERAL` double(18,8) DEFAULT NULL,
  `PERC_IBPTESTADUAL` double(18,8) DEFAULT NULL,
  `VALOR_IBPTESTADUAL` double(18,8) DEFAULT NULL,
  `PERC_IBPTMUNICIPAL` double(18,8) DEFAULT NULL,
  `VALOR_IBPTMUNICIPAL` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSDESONERADO` double(18,8) DEFAULT NULL,
  `PERCICMSDESONERADO` double(18,8) DEFAULT NULL,
  `VALORICMSDESONERADO` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSINTUFDESTINO` double(18,8) DEFAULT NULL,
  `PERC_ICMSINTPARTILHA` double(18,8) DEFAULT NULL,
  `PERC_ICMSINTFCPUFDESTINO` double(18,8) DEFAULT NULL,
  `VALOR_ICMSINTFCPUFDESTINO` double(18,8) DEFAULT NULL,
  `PERC_ICMSINTUFDESTINO` double(18,8) DEFAULT NULL,
  `VALOR_ICMSINTUFDESTINO` double(18,8) DEFAULT NULL,
  `PERC_ICMSINTUFENVOLVIDA` double(18,8) DEFAULT NULL,
  `VALOR_ICMSINTUFORIGEM` double(18,8) DEFAULT NULL,
  `VALORTOTALIMPOSTOPERFIL` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSFCP` double(18,8) DEFAULT NULL,
  `PERCICMSFCP` double(18,8) DEFAULT NULL,
  `VALORICMSFCP` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSSTFCP` double(18,8) DEFAULT NULL,
  `PERCICMSSTFCP` double(18,8) DEFAULT NULL,
  `VALORICMSSTFCP` double(18,8) DEFAULT NULL,
  `PERCMERCDEVOLVIDA` double(18,8) DEFAULT NULL,
  `VALORIPIDEVOLVIDO` double(18,8) DEFAULT NULL,
  `BASECALCULOIMPOSTOIMPORTACAO` double(18,8) DEFAULT NULL,
  `VALORDESPESASADUANEIRAS` double(18,8) DEFAULT NULL,
  `VALORIOFIMPORTACAO` double(18,8) DEFAULT NULL,
  `VALORIMPOSTOIMPORTACAO` double(18,8) DEFAULT NULL,
  `BASECALCULOICMSSTRETIDO` double(18,8) DEFAULT NULL,
  `PERCICMSSTSUPORTADO` double(18,8) DEFAULT NULL,
  `VALORICMSSUBSTITUTO` double(18,8) DEFAULT NULL,
  `VALORICMSSTRETIDO` double(18,8) DEFAULT NULL,
  `VALORDESCONTOBENEFICIOS` double(18,8) DEFAULT NULL,
  `BASECALCULOPISBENEF` double(18,8) DEFAULT NULL,
  `PERCPISBENEF` double(18,8) DEFAULT NULL,
  `VALORPISBENEF` double(18,8) DEFAULT NULL,
  `BASECALCULOCOFINSBENEF` double(18,8) DEFAULT NULL,
  `PERCCOFINSBENEF` double(18,8) DEFAULT NULL,
  `VALORCOFINSBENEF` double(18,8) DEFAULT NULL,
  `VALORBENEFICIOFISCALPRESUMIDO` double(18,8) DEFAULT NULL,
  `PERCBENEFICIOFISCALPRESUMIDO` double(18,8) DEFAULT NULL,
  `BASEBENEFICIOFISCALPRESUMIDO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemcomanda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemcomanda` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `STATUSCOMANDAAPTO` varchar(30) DEFAULT NULL,
  `IDOPERADORCOMANDAAPTO` int(30) DEFAULT NULL,
  `DATAFINALIZACAOCOMANDAAPTO` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`,`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akDocumentoItem` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`)
) ENGINE=InnoDB AUTO_INCREMENT=109057 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemcomissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemcomissao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `CODIGOVENDEDOR` varchar(20) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VEN_CLASSIFICACAO` varchar(30) NOT NULL,
  `PERCCOMISSAO` double(18,8) NOT NULL,
  `VALORCOMISSAO` double(18,8) NOT NULL,
  `VALORORIGEMCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`CODIGOVENDEDOR`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGOVENDEDOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemexpedicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemexpedicao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMITEM` varchar(30) NOT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL,
  `QUANTIDADEEXP` double(18,8) NOT NULL,
  `DATAHORAGRAVACAO` datetime NOT NULL,
  `NOMEUSUARIOLOGADO` varchar(40) NOT NULL,
  `ID_EXPEDICAOPED` int(10) unsigned NOT NULL,
  `ORIGEM` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkExpedicaoPed` (`EMP_ID`,`ID_EXPEDICAOPED`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemimportacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemimportacao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `SEQUENCIALDI` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERODI` varchar(12) NOT NULL,
  `DATAREGISTRO` datetime NOT NULL,
  `LOCALDESEMBARACO` varchar(60) NOT NULL,
  `UFDESEMBARACO` char(2) NOT NULL,
  `DATADESEMBARACO` datetime NOT NULL,
  `CODEXPORTADOR` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`SEQUENCIALDI`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemimportacaoadicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemimportacaoadicao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `SEQUENCIALDI` int(10) unsigned NOT NULL,
  `SEQUENCIALADICAO` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMEROADICAO` int(3) unsigned NOT NULL,
  `NUMSEQITEMADICAO` int(3) unsigned NOT NULL,
  `CODIGOFABRICANTEEST` varchar(60) NOT NULL,
  `VALORDESCONTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`SEQUENCIALDI`,`SEQUENCIALADICAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkSeqDI` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`SEQUENCIALDI`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentoitemrastreabilidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentoitemrastreabilidade` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMEROLOTE` varchar(20) DEFAULT NULL,
  `QTDELOTE` double(22,0) DEFAULT NULL,
  `DATAFABRICACAO` datetime DEFAULT NULL,
  `DATAVALIDADE` datetime DEFAULT NULL,
  `VALORMAXCOSUMIDOR` double(18,8) DEFAULT NULL,
  `CODPRODANVISA` varchar(15) DEFAULT NULL,
  `CODAGREGACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`ID`) USING BTREE,
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documentorodape`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentorodape` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTRANSPORTADORA` varchar(20) DEFAULT NULL,
  `CODIGOENDERECOTRANSPORTADORA` int(11) DEFAULT NULL,
  `CODIGOCONTATOTRANSPORTADORA` int(11) DEFAULT NULL,
  `MODALIDADEFRETE` varchar(20) DEFAULT NULL,
  `UFVEICULO` char(2) DEFAULT NULL,
  `PLACAVEICULO` varchar(20) DEFAULT NULL,
  `ESPECIEVOLUMES` varchar(40) DEFAULT NULL,
  `QTDVOLUMES` double(18,8) DEFAULT NULL,
  `NUMEROVOLUMES` int(11) DEFAULT NULL,
  `PESOBRUTO` double(18,8) DEFAULT NULL,
  `PESOLIQUIDO` double(18,8) DEFAULT NULL,
  `LOCALENTREGADIFDESTINO` char(1) NOT NULL,
  `CNPJCPFDESTINO` varchar(14) DEFAULT NULL,
  `LOGRADOURODESTINO` varchar(100) DEFAULT NULL,
  `NUMERODESTINO` varchar(60) DEFAULT NULL,
  `COMPLEMENTODESTINO` varchar(60) DEFAULT NULL,
  `BAIRRODESTINO` varchar(60) DEFAULT NULL,
  `CODIGOMUNICIPIODESTINO` int(11) DEFAULT NULL,
  `SIGLAUFDESTINO` char(2) DEFAULT NULL,
  `CODIGOENDDIFENTREGA` int(11) DEFAULT NULL,
  `UFEMBARQUEEXPORTACAO` char(2) DEFAULT NULL,
  `LOCALEMBARQUEEXPORTACAO` varchar(60) DEFAULT NULL,
  `CODIGOANTT` varchar(22) DEFAULT NULL,
  `CONTATOENTREGA` varchar(100) DEFAULT NULL,
  `CODIGONATUREZAFRETE` char(1) DEFAULT NULL,
  `CTE_CIDADEINIPREST` varchar(50) DEFAULT NULL,
  `CTE_UFINIPREST` char(2) DEFAULT NULL,
  `CTE_CIDADEFIMPREST` varchar(50) DEFAULT NULL,
  `CTE_UFFIMPREST` char(2) DEFAULT NULL,
  `CALCULARPESOMANUAL` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOTRANSPORTADORA`),
  KEY `fkEnderecoPessoa` (`EMP_ID`,`CODIGOTRANSPORTADORA`,`CODIGOENDERECOTRANSPORTADORA`),
  KEY `fkContatoPessoa` (`EMP_ID`,`CODIGOTRANSPORTADORA`,`CODIGOCONTATOTRANSPORTADORA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `docvencimentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docvencimentos` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PARCELA` int(10) unsigned NOT NULL,
  `DOCUMENTO` varchar(20) NOT NULL,
  `DATAVENCIMENTO` date NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `VALORBRUTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email` (
  `ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IDCONTAEMAIL` int(11) NOT NULL,
  `DATAENVIO` datetime DEFAULT NULL,
  `DE` varchar(400) DEFAULT NULL,
  `PARA` varchar(400) DEFAULT NULL,
  `CC` varchar(400) DEFAULT NULL,
  `CCO` varchar(400) DEFAULT NULL,
  `ASSUNTO` varchar(300) DEFAULT NULL,
  `CORPO` text,
  `TIPOANEXO` varchar(50) DEFAULT NULL,
  `NOMEREMETENTE` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `akEmail1` (`IDCONTAEMAIL`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emailanexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emailanexo` (
  `IDEMAIL` int(11) NOT NULL,
  `SEQUENCIAL` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ANEXOS` longblob NOT NULL,
  `NOMEARQUIVOANEXO` varchar(80) NOT NULL,
  PRIMARY KEY (`IDEMAIL`,`SEQUENCIAL`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emissaocheque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emissaocheque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `NOMEPESSOA` varchar(100) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  `DATA` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOUSUARIO`,`CHAVE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkFinanceiro` (`EMP_ID`,`CHAVE`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_RAZAOSOCIAL` varchar(100) NOT NULL DEFAULT '',
  `EMP_NOMEFANTASIA` varchar(100) NOT NULL DEFAULT '',
  `EMP_CNPJ` varchar(14) DEFAULT NULL,
  `EMP_INSCRICAOESTADUAL` varchar(20) DEFAULT NULL,
  `EMP_INSCRICAOMUNICIPAL` varchar(20) DEFAULT NULL,
  `EMP_LOGRADOURO` varchar(70) DEFAULT NULL,
  `EMP_NUMERO` int(11) DEFAULT NULL,
  `EMP_COMPLEMENTO` varchar(25) DEFAULT NULL,
  `EMP_BAIRRO` varchar(20) DEFAULT NULL,
  `EMP_CIDADE` varchar(30) DEFAULT NULL,
  `EMP_CEP` varchar(8) DEFAULT NULL,
  `EMP_FONE` varchar(12) DEFAULT NULL,
  `EMP_FAX` varchar(12) DEFAULT NULL,
  `EST_SIGLA` char(2) DEFAULT NULL,
  `EMP_RESPONSAVEL` varchar(30) DEFAULT NULL,
  `EMP_CODIGONIVELSUPERIOR` int(11) DEFAULT NULL,
  `EMP_TIPOHIERARQUIA` varchar(10) NOT NULL DEFAULT '',
  `EMP_PERGUNTAORCAMENTO` char(1) NOT NULL DEFAULT '',
  `EMP_TIPOEMPRESA` int(11) NOT NULL DEFAULT '0',
  `NUMEROULTIMONSU` int(11) NOT NULL DEFAULT '0',
  `EMP_NOMECONTABILISTA` varchar(60) DEFAULT NULL,
  `EMP_CPFCONTABILISTA` varchar(14) DEFAULT NULL,
  `EMP_CRCCONTABILISTA` varchar(14) DEFAULT NULL,
  `EMP_CNPJCONTABILISTA` varchar(14) DEFAULT NULL,
  `EMP_CEPCONTABILISTA` varchar(8) DEFAULT NULL,
  `EMP_LOGRADOUROCONTABILISTA` varchar(70) DEFAULT NULL,
  `EMP_NUMEROCONTABILISTA` varchar(10) DEFAULT NULL,
  `EMP_COMPLEMENTOCONTABILISTA` varchar(25) DEFAULT NULL,
  `EMP_BAIRROCONTABILISTA` varchar(20) DEFAULT NULL,
  `EMP_FONECONTABILISTA` varchar(12) DEFAULT NULL,
  `EMP_FAXCONTABILISTA` varchar(12) DEFAULT NULL,
  `EMP_EMAILCONTABILISTA` varchar(100) DEFAULT NULL,
  `EMP_CIDADECONTABILISTA` varchar(30) DEFAULT NULL,
  `EST_SIGLACONTABILISTA` char(2) DEFAULT NULL,
  `EMP_SUFRAMA` varchar(20) DEFAULT NULL,
  `EMP_FORMATRIBUTACAO` varchar(25) NOT NULL,
  `EMP_CODIGONABOSCH` varchar(25) DEFAULT NULL,
  `EMP_INDNATUREZA` char(2) DEFAULT NULL,
  `EMP_INDATIV` char(2) DEFAULT NULL,
  `EMP_IDMATRIZ` varchar(20) DEFAULT NULL,
  `EMP_IDTRANSFERENCIA` varchar(20) DEFAULT NULL,
  `EMP_CODCLI` varchar(20) DEFAULT NULL,
  `EMP_CODFORN` varchar(20) DEFAULT NULL,
  `EMP_CMC` varchar(15) DEFAULT NULL,
  `EMP_DESATIVADA` char(50) NOT NULL,
  `EMP_CODRECEITAICMS` varchar(20) DEFAULT NULL,
  `EMP_CODRECEITAPIS` varchar(20) DEFAULT NULL,
  `EMP_CODRECEITACOFINS` varchar(20) DEFAULT NULL,
  `EMP_EMAIL` varchar(100) DEFAULT NULL,
  `EMP_REGTRIB` char(2) DEFAULT NULL,
  `EMP_RNTRC` varchar(8) DEFAULT NULL,
  `EMP_LGPDPOFONE` varchar(12) DEFAULT NULL,
  `EMP_LGPDPONOME` varchar(30) DEFAULT NULL,
  `EMP_LGPDPOEMAIL` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresaMatriz` (`EMP_IDMATRIZ`),
  KEY `fkEmpresaTrasnf` (`EMP_IDTRANSFERENCIA`),
  KEY `fkCliente` (`EMP_ID`,`EMP_CODCLI`),
  KEY `fkFornecedor` (`EMP_ID`,`EMP_CODFORN`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `empresacnae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresacnae` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CNA_CODIGO` varchar(10) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CNA_CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `empresaieest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresaieest` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `EST_SIGLAST` char(2) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_INSCRESTADUALST` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`EST_SIGLAST`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `empresatributacaomunicipal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresatributacaomunicipal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOATIVIDADE` varchar(15) DEFAULT '',
  `CODIGOTRIBUTACAONFSE` varchar(20) DEFAULT NULL,
  `OPCOESESPECIFICAS` varchar(32) DEFAULT '',
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endereco` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `END_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `END_TIPOENDERECO` varchar(20) NOT NULL DEFAULT '',
  `END_LOGRADOURO` varchar(100) NOT NULL DEFAULT '',
  `END_BAIRRO` varchar(30) NOT NULL DEFAULT '',
  `END_CIDADE` varchar(50) NOT NULL DEFAULT '',
  `END_UF` char(2) NOT NULL DEFAULT '',
  `END_CEP` varchar(8) NOT NULL DEFAULT '',
  `END_CXPOSTAL` varchar(10) DEFAULT NULL,
  `END_NUMERO` varchar(6) NOT NULL DEFAULT '',
  `END_COMPLEMENTO` varchar(30) DEFAULT '',
  `END_PAIS` varchar(50) DEFAULT '',
  `END_PESESTRANGEIRO` char(1) NOT NULL DEFAULT '',
  `END_CODRECPETORBOSCH` varchar(20) DEFAULT '',
  `END_PRINCIPAL` char(1) DEFAULT '',
  `IDSALESFORCE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`END_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `enquadramentoipi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquadramentoipi` (
  `ENQ_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ENQ_CODIGO` varchar(3) DEFAULT NULL,
  `ENQ_CATEGORIA` int(10) NOT NULL,
  `ENQ_DESC` varchar(600) NOT NULL,
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`ENQ_ID`),
  KEY `akENQ1` (`ENQ_CODIGO`),
  KEY `akENQ2` (`ENQ_DESC`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `equipamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCENTROCUSTO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTURNO1` int(11) DEFAULT NULL,
  `CODIGOTURNO2` int(11) DEFAULT NULL,
  `CODIGOTURNO3` int(11) DEFAULT NULL,
  `CODIGOOPERADOR` int(11) DEFAULT NULL,
  `SEQUENCIALVISUALIZACAO` int(11) DEFAULT NULL,
  `DESATIVADO` char(1) DEFAULT NULL,
  `PREPRODUCAO` char(1) NOT NULL DEFAULT 'N',
  `VALORCUSTOHORA` double(18,8) DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`),
  KEY `fkOperador` (`EMP_ID`,`CODIGOOPERADOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `equipamentomaquinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipamentomaquinas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOEQUIPAMENTO` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTAREFA` int(11) NOT NULL DEFAULT '0',
  `ORIGEMMAQUINA` char(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOEQUIPAMENTO`,`CODIGOMAQUINA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEquipamento` (`EMP_ID`,`CODIGOEQUIPAMENTO`),
  KEY `fkMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkTarefa` (`EMP_ID`,`CODIGOTAREFA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `equipamentoservicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipamentoservicos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOEQUIPAMENTO` int(11) NOT NULL DEFAULT '0',
  `CODIGOSERVICO` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '1',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTAREFA` int(11) NOT NULL DEFAULT '0',
  `ORIGEMSERVICO` char(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOEQUIPAMENTO`,`CODIGOSERVICO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEquipamento` (`EMP_ID`,`CODIGOEQUIPAMENTO`),
  KEY `fkTarefa` (`EMP_ID`,`CODIGOTAREFA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `EST_SIGLA` char(2) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EST_NOME` varchar(50) NOT NULL DEFAULT '',
  `FORMATRIBUTACAODIFAL` int(11) DEFAULT '1' COMMENT '1 = Calcular Difal - Base Única, 2 = Calcular Difal - Base Dupla',
  PRIMARY KEY (`EST_SIGLA`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DOC_ID` int(10) unsigned DEFAULT NULL,
  `CLASSIFICACAO` int(10) unsigned DEFAULT NULL,
  `SEQUENCIALITEM` int(10) unsigned DEFAULT NULL,
  `DATAOPERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `JUSTIFICATIVA` varchar(100) DEFAULT NULL,
  `TIPOOPERACAO` char(1) NOT NULL DEFAULT '',
  `ORIGEM` char(2) NOT NULL DEFAULT '' COMMENT 'AC - Acerto de estoque\r\nBR - Baixa de requisição\r\nBV - Baixa de pedido de venda\r\nEM - Entrada de Materiais (Nota de Compra)\r\nEP - Empenhado de Produção\r\nER - Empenhado de requisição\r\nNF - Nota de Venda\r\nOP - Baixa da Ordem de Produção\r\nPC - Empenhado de Compra (Pedido de Compra)\r\nPV - Empenhado de Venda (Pedido de Venda)',
  `NOTASERIE` varchar(20) DEFAULT NULL,
  `NOTANUMERO` int(11) DEFAULT NULL,
  `NOTASEQUENCIALITEM` int(11) DEFAULT NULL,
  `CODIGOREQUISICAO` int(11) DEFAULT NULL,
  `CODIGOREQUISICAOITEM` int(11) DEFAULT NULL,
  `CODIGOOS` varchar(20) DEFAULT NULL,
  `CODIGOENTRADA` varchar(20) DEFAULT NULL,
  `ORIGEMMATERIAL` char(1) NOT NULL DEFAULT '',
  `CODIGOMATERIAL` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOMATERIAL` varchar(200) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `MOVIMENTARVALORMEDIO` char(1) NOT NULL DEFAULT 'N',
  `VALORMEDIO` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` varchar(100) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAGRAVACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `PREVISAO` char(1) NOT NULL DEFAULT '',
  `SEQUENCIALITEMENTRADA` int(11) DEFAULT NULL,
  `NUMEROPEDIDOCOMPRA` varchar(20) DEFAULT NULL,
  `SEQUENCIALITEMPEDIDOCOMPRA` int(11) DEFAULT NULL,
  `CODIGOPRODUTOCOMPOSTO` varchar(20) DEFAULT NULL,
  `CODIGOORIGEM` int(11) DEFAULT NULL,
  `TIPOBAIXA` varchar(20) NOT NULL,
  `CODIGOLOTEFSC` varchar(40) DEFAULT NULL,
  `USOCONSUMO` char(1) NOT NULL DEFAULT 'X',
  `CODTIPOMOVESTOQUE` varchar(20) DEFAULT NULL,
  `LOC_ID` int(11) DEFAULT NULL,
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `CODACERTO` varchar(20) DEFAULT NULL,
  `IDOPPRODUTO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `akEstoque3` (`EMP_ID`,`ORIGEM`,`NUMEROPEDIDOCOMPRA`,`SEQUENCIALITEMPEDIDOCOMPRA`,`DATAOPERACAO`,`CANCELADO`),
  KEY `akEstoque2` (`EMP_ID`,`ORIGEM`,`ORIGEMMATERIAL`,`CODIGOMATERIAL`,`TIPOOPERACAO`,`DATAOPERACAO`,`CANCELADO`),
  KEY `akEstoque1` (`EMP_ID`,`ORIGEM`,`TIPOOPERACAO`,`ORIGEMMATERIAL`,`CODIGOMATERIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkReqEstoque` (`EMP_ID`,`CODIGOREQUISICAO`),
  KEY `fkReqItemEstoque` (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGOREQUISICAOITEM`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOS`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkLoteFSC` (`EMP_ID`,`CODIGOLOTEFSC`),
  KEY `fkTipoMovEstoque` (`EMP_ID`,`CODTIPOMOVESTOQUE`),
  KEY `fkLocalEstoque` (`EMP_ID`,`LOC_ID`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akEstoque4` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `akEstoque5` (`EMP_ID`,`CODIGOORIGEM`),
  KEY `akEstoque6` (`EMP_ID`,`ORIGEMMATERIAL`,`CODIGOMATERIAL`,`CANCELADO`,`DATAOPERACAO`),
  KEY `fkAcerto` (`EMP_ID`,`CODACERTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `estoque_precomedio_comandos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_precomedio_comandos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA_LANCAMENTO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DATA_OPERACAOESTOQUE` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ORIGEMITEM` char(1) NOT NULL DEFAULT '',
  `CODIGOITEM` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `TIPOACAO` varchar(30) NOT NULL DEFAULT '',
  `TIPOOPERACAO` char(1) NOT NULL DEFAULT '',
  `ORIGEMLANCAMENTO` char(2) NOT NULL DEFAULT '',
  `CODIGOESTOQUE` int(11) DEFAULT NULL,
  `CODIGOACERTO` varchar(20) DEFAULT NULL,
  `CODIGOOS` varchar(20) DEFAULT NULL,
  `CODIGOREQUISICAO` int(11) DEFAULT NULL,
  `CODIGOREQUISICAOITEM` int(10) DEFAULT NULL,
  `CLASSIFICACAO` int(10) DEFAULT NULL,
  `DOC_ID` int(10) DEFAULT NULL,
  `SEQUENCIALITEM` int(10) DEFAULT NULL,
  `PROCESSADO` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akEstoquePMedioComandos` (`EMP_ID`,`ORIGEMLANCAMENTO`,`TIPOOPERACAO`,`ORIGEMITEM`,`CODIGOITEM`),
  KEY `fkEstoque` (`EMP_ID`,`CODIGOESTOQUE`),
  KEY `fkNF` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`,`SEQUENCIALITEM`),
  KEY `fkAcerto` (`EMP_ID`,`CODIGOACERTO`),
  KEY `fkReqEstoqueItem` (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGOREQUISICAOITEM`),
  KEY `fkMaterial` (`EMP_ID`,`ORIGEMITEM`,`CODIGOITEM`),
  KEY `akProcessado` (`PROCESSADO`)
) ENGINE=MyISAM AUTO_INCREMENT=731818 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `estoqueitemsaldo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoqueitemsaldo` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORIGEMITEM` char(1) NOT NULL DEFAULT '0',
  `CODIGOITEM` varchar(20) NOT NULL DEFAULT '0',
  `SALDOFISICO` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`ID`),
  KEY `ak_item` (`EMP_ID`,`ORIGEMITEM`,`CODIGOITEM`)
) ENGINE=InnoDB AUTO_INCREMENT=341012 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `estoqueterceiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoqueterceiros` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DOC_ID` int(10) unsigned DEFAULT NULL,
  `CLASSIFICACAO` int(10) unsigned DEFAULT NULL,
  `SEQUENCIALITEM` int(10) unsigned DEFAULT NULL,
  `DATAOPERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TIPOOPERACAO` char(1) NOT NULL DEFAULT '',
  `ORIGEM` char(2) NOT NULL DEFAULT '',
  `NOTASERIE` varchar(20) DEFAULT NULL,
  `NOTANUMERO` int(11) DEFAULT NULL,
  `CODPARTICIPANTE` varchar(20) DEFAULT NULL,
  `ORIGEMITEM` char(1) NOT NULL DEFAULT '',
  `CODIGOITEM` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOITEM` varchar(200) NOT NULL DEFAULT '',
  `INDICADORESTOQUE` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL DEFAULT '',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAGRAVACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TIPOITEM` varchar(2) NOT NULL,
  `CODACERTO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `etiquetaperfil001`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etiquetaperfil001` (
  `EMP_ID` int(10) unsigned NOT NULL DEFAULT '0',
  `ID_ETIQUETA` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORS_ID` varchar(11) NOT NULL DEFAULT '',
  `NUMEROPEDIDO` varchar(20) DEFAULT NULL,
  `NUMEROINICIAL` int(11) DEFAULT NULL,
  `NUMEROFINAL` int(11) DEFAULT NULL,
  `QTDPORCAIXA` int(11) NOT NULL,
  `NUMTOTALPARCELAS` int(11) NOT NULL,
  `QTDUNIDADES` double(18,8) NOT NULL,
  `SEQPARCELA` int(11) NOT NULL,
  `NUMEROINICIALPARCELA` int(11) DEFAULT NULL,
  `NUMEROFINALPARCELA` int(11) DEFAULT NULL,
  `SEQETIQUETA` int(11) NOT NULL,
  `QTDPORETIQUETA` int(11) NOT NULL,
  `INFORMARNUMINICIALFINAL` char(1) NOT NULL,
  `DESCRICAO` longtext NOT NULL,
  PRIMARY KEY (`ID_ETIQUETA`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `etiquetaperfil002`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etiquetaperfil002` (
  `EMP_ID` int(10) unsigned NOT NULL DEFAULT '0',
  `ID_ETIQUETA` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORS_ID` varchar(11) NOT NULL DEFAULT '',
  `ORS_DESCRICAO` longtext,
  `NUMEROPEDIDO` varchar(20) DEFAULT NULL,
  `NUMERONF` varchar(20) DEFAULT NULL,
  `PES_NOME_RAZAO` varchar(100) NOT NULL DEFAULT '',
  `PES_CNPJ` varchar(14) DEFAULT NULL,
  `END_LOGRADOURO` varchar(70) NOT NULL DEFAULT '',
  `END_BAIRRO` varchar(30) NOT NULL DEFAULT '',
  `END_CIDADE` varchar(30) NOT NULL DEFAULT '',
  `END_UF` char(2) NOT NULL DEFAULT '',
  `END_CEP` varchar(8) NOT NULL DEFAULT '',
  `NUMEROINICIAL` int(11) DEFAULT NULL,
  `NUMEROFINAL` int(11) DEFAULT NULL,
  `QTDPORCAIXA` int(11) NOT NULL,
  `NUMTOTALPARCELAS` int(11) NOT NULL,
  `QTDUNIDADES` double(18,8) NOT NULL,
  `SEQPARCELA` int(11) NOT NULL,
  `NUMEROINICIALPARCELA` int(11) DEFAULT NULL,
  `NUMEROFINALPARCELA` int(11) DEFAULT NULL,
  `SEQETIQUETA` int(11) NOT NULL,
  `QTDPORETIQUETA` int(11) NOT NULL,
  `INFORMARNUMINICIALFINAL` char(1) NOT NULL,
  PRIMARY KEY (`ID_ETIQUETA`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `etiquetasexpedicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etiquetasexpedicao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(11) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADEPOREMBALAGEM` double(18,8) NOT NULL,
  `QUANTIDADEPRODUZIDA` double(18,8) NOT NULL,
  `QUANTIDADETOTAL` double(18,8) NOT NULL,
  `NOMECLIENTE` varchar(110) NOT NULL DEFAULT '',
  `DESCRICAOORCAMENTO` longtext,
  `NUMEROLOTE` varchar(7) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `expedicaopedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedicaopedido` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `ID_EXPEDICAOPED` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL,
  `QUANTIDADEEXP` double(18,8) NOT NULL,
  `FATURADA` char(1) NOT NULL,
  `DATAHORAGRAVACAO` datetime NOT NULL,
  `NOMEUSUARIOLOGADO` varchar(40) NOT NULL,
  `SERIENF` varchar(20) NOT NULL,
  `NUMERONF` int(11) NOT NULL,
  `ORIGEMITEM` varchar(40) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_EXPEDICAOPED`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fatorconversaounidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fatorconversaounidade` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FCU_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FCU_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `FCU_FATOR` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`FCU_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fciitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fciitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FCI_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOTEENVIO_ID` int(11) NOT NULL DEFAULT '0',
  `ORIGEMMERCADORIA` varchar(20) NOT NULL DEFAULT '',
  `CODMERCADORIA` varchar(50) NOT NULL DEFAULT '',
  `DESCRICAOMERCADORIA` varchar(255) NOT NULL DEFAULT '',
  `CODIGONCM` varchar(10) DEFAULT '',
  `CODIGOGTIN` varchar(14) DEFAULT '',
  `UNIDADEMERCADORIA` varchar(6) NOT NULL DEFAULT '',
  `VALORUNITMEDIOIMPORTACAOMES` double(18,8) NOT NULL,
  `VALORUNITMEDIOVENDASMES` double(18,8) NOT NULL,
  `VALORPARCELAIMPORTADA` double(18,8) NOT NULL,
  `CIANTERIOR` double(18,8) NOT NULL,
  `CIATUAL` double(18,8) NOT NULL,
  `CODIGOFCI` char(36) DEFAULT '',
  `LISTAOPSCALCULO` varchar(400) NOT NULL DEFAULT '',
  PRIMARY KEY (`FCI_ID`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkLoteFCI` (`EMP_ID`,`LOTEENVIO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fcilote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fcilote` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOTE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEARQUIVOENVIADO` varchar(240) DEFAULT '',
  `DATAGERACAOARQUIVO` datetime DEFAULT NULL,
  `CODRECEPCAOARQUIVO` varchar(20) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`LOTE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `feriado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feriado` (
  `ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FER_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `DIA` int(11) NOT NULL,
  `MES` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `financeiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financeiro` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `CHAVEBAIXAPAGAR` int(11) NOT NULL DEFAULT '0',
  `CHAVEBAIXARECEBER` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DOC_ID` int(10) unsigned DEFAULT NULL,
  `CLASSIFICACAO` int(10) unsigned DEFAULT NULL,
  `SEQUENCIALITEM` int(10) unsigned DEFAULT NULL,
  `CHAVEDOLOTE` int(11) NOT NULL DEFAULT '0',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `NRODOCORIGEM` int(11) DEFAULT NULL,
  `SEQNRODOCORIGEM` varchar(20) NOT NULL DEFAULT '',
  `SERIEDOCORIGEM` varchar(20) DEFAULT NULL,
  `DATACONTABIL` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DATALANCAMENTO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DATAEMISSAO` datetime DEFAULT NULL,
  `DATAVENCIMENTO` datetime DEFAULT NULL,
  `DATAPREVISTA` date NOT NULL,
  `DEBITOCODREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `CREDITOCODREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `DEBITOCODCONTABIL` varchar(20) NOT NULL DEFAULT '',
  `CREDITOCODCONTABIL` varchar(20) NOT NULL DEFAULT '',
  `NUMEROTITULO` varchar(20) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `CODIGOHISTORICO` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOHISTORICO` varchar(100) NOT NULL DEFAULT '',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `TIPOPAGAMENTO` varchar(20) DEFAULT NULL,
  `DATAPAGAMENTO` datetime DEFAULT NULL,
  `NUMEROCONTABANCARIA` bigint(20) NOT NULL,
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `PREVISAO` char(1) DEFAULT NULL,
  `OBSERVACOES` varchar(500) DEFAULT NULL,
  `MEIOPAGAMENTO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOCONTABANCARIA` varchar(20) NOT NULL DEFAULT '',
  `ACRESCIMO` double(18,8) NOT NULL,
  `PERCACRESCIMO` double(18,8) NOT NULL,
  `DESCONTO` double(18,8) NOT NULL,
  `PERCDESCONTO` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `NOMEPESSOA` varchar(50) NOT NULL DEFAULT '',
  `FLAGPODEALTERAR` char(1) NOT NULL DEFAULT '',
  `ULTIMONOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `ULTIMOLOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `ULTIMOCODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `PERCJUROS` double(18,8) NOT NULL,
  `NUMERODOBANCO` int(11) NOT NULL DEFAULT '0',
  `FLAGLANCGERADOSISTEMA` char(1) NOT NULL DEFAULT '',
  `FLAGLANCCANCELADO` char(1) NOT NULL DEFAULT '',
  `CHAVEBAIXAPAI` int(11) NOT NULL DEFAULT '0',
  `FLAGTIPOMOVMANUAL` int(11) NOT NULL DEFAULT '0',
  `CODIGOENTRADA` varchar(20) DEFAULT NULL,
  `PARCELAPAGTOENTRADA` int(11) DEFAULT NULL,
  `NUMEROPEDIDOCOMPRA` varchar(20) DEFAULT NULL,
  `PARCELAPAGTOPEDIDOCOMPRA` int(11) DEFAULT NULL,
  `CODIGOPERFILCOBRANCA` int(11) DEFAULT NULL,
  `DESCRICAOPERFILCOBRANCA` varchar(50) DEFAULT NULL,
  `VALORDOCORIGEM` double(18,8) DEFAULT NULL,
  `VALORPARCELADOCORIGEM` double(18,8) DEFAULT NULL,
  `PERCCOMISS` double(18,8) DEFAULT NULL,
  `SALDO` double(18,8) NOT NULL,
  `DATALIQUIDACAO` datetime DEFAULT NULL,
  `CODIGORECIBO` int(11) DEFAULT '0',
  `CHAVEBAIXARECEBERPAI` int(11) DEFAULT NULL,
  `COMISSAOPGAANTECIPADA` char(1) DEFAULT NULL,
  `ESTORNO` char(1) DEFAULT NULL,
  `BOLETORECEBIDO` char(1) NOT NULL DEFAULT '',
  `DDARECEBIDO` char(1) NOT NULL DEFAULT '',
  `BASECALCULOCOMISSAO` double(18,8) DEFAULT NULL,
  `VALORJUROS` double(18,8) DEFAULT NULL,
  `RENEGOCIACAO` char(1) DEFAULT 'N',
  `INFORMACOESNOTA` varchar(50) DEFAULT NULL,
  `DESPESABANCARIA` double(18,8) DEFAULT NULL,
  `NRO_OP` varchar(20) NOT NULL DEFAULT '',
  `PERCMULTA` double(18,8) DEFAULT NULL,
  `VALORMULTA` double(18,8) DEFAULT NULL,
  `CHAVEDOCORIGEM` int(11) DEFAULT NULL,
  `IDBANDEIRACARTAO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CHAVE`,`CHAVEBAIXAPAGAR`,`CHAVEBAIXARECEBER`),
  KEY `akFinanceiro1` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `akFinanceiro2` (`EMP_ID`,`ORIGEM`,`DATAVENCIMENTO`),
  KEY `akFinanceiro3` (`EMP_ID`,`ORIGEM`,`NRODOCORIGEM`,`SERIEDOCORIGEM`),
  KEY `akFinanceiro4` (`EMP_ID`,`CHAVEBAIXAPAI`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPagar` (`EMP_ID`,`CHAVEBAIXAPAGAR`),
  KEY `fkReceber` (`EMP_ID`,`CHAVEBAIXARECEBER`),
  KEY `fkCodReduzDebito` (`EMP_ID`,`DEBITOCODREDUZIDO`),
  KEY `fkCodReduzCredito` (`EMP_ID`,`CREDITOCODREDUZIDO`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `fkHistorico` (`EMP_ID`,`CODIGOHISTORICO`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkTipoPagto` (`EMP_ID`,`TIPOPAGAMENTO`),
  KEY `fkMeiosPagto` (`EMP_ID`,`MEIOPAGAMENTO`),
  KEY `fkContaBancaria` (`EMP_ID`,`CODIGOCONTABANCARIA`),
  KEY `fkUltimoUsuario` (`ULTIMOCODIGOUSUARIO`),
  KEY `fkRecibo` (`EMP_ID`,`CODIGORECIBO`),
  KEY `fkReceberpai` (`EMP_ID`,`CHAVEBAIXARECEBERPAI`),
  KEY `akFinanceiro5` (`EMP_ID`,`DATAPAGAMENTO`,`ORIGEM`),
  KEY `akFinanceiro6` (`EMP_ID`,`DATALIQUIDACAO`,`ORIGEM`),
  KEY `akFinanceiro7` (`EMP_ID`,`DATAEMISSAO`,`ORIGEM`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akFinanceiro8` (`EMP_ID`,`ORIGEM`,`CODIGOPESSOA`,`SALDO`,`DATAVENCIMENTO`),
  KEY `akFinanceiro9` (`EMP_ID`,`CODIGOCONTABANCARIA`,`ORIGEM`,`PREVISAO`,`FLAGLANCCANCELADO`,`ESTORNO`),
  KEY `akFinanceiro10` (`EMP_ID`,`ORIGEM`,`DATAPREVISTA`),
  KEY `akFinanceiro11` (`EMP_ID`,`ORIGEM`,`CODIGOPESSOA`,`SALDO`,`DATAPREVISTA`),
  KEY `akFinanceiro12` (`EMP_ID`,`NRO_OP`,`PREVISAO`),
  KEY `fk_FinanceiroChaveOrigem` (`EMP_ID`,`CHAVEDOCORIGEM`,`ORIGEM`),
  KEY `ak_Financeiro13` (`EMP_ID`,`CREDITOCODCONTABIL`),
  KEY `ak_Financeiro14` (`EMP_ID`,`DEBITOCODCONTABIL`),
  KEY `ak_Financeiro15` (`EMP_ID`,`FLAGLANCCANCELADO`,`ESTORNO`,`PREVISAO`,`DATACONTABIL`,`CREDITOCODCONTABIL`),
  KEY `ak_Financeiro16` (`EMP_ID`,`FLAGLANCCANCELADO`,`ESTORNO`,`PREVISAO`,`DATAVENCIMENTO`,`CREDITOCODCONTABIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `financeiroarquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financeiroarquivos` (
  `EMP_ID` int(10) NOT NULL,
  `CHAVE` int(10) NOT NULL,
  `ID_ARQUIVO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CHAVE`,`ID_ARQUIVO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoanilox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoanilox` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(60) NOT NULL DEFAULT '',
  `LINEATURA` varchar(20) NOT NULL DEFAULT '',
  `BCM` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexocliche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexocliche` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `NUMERODENTESZ` double(18,8) NOT NULL DEFAULT '0.00000000',
  `FATORAJUSTE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `REPETICAO1` double(18,8) NOT NULL,
  `REPETICAO2` double(18,8) NOT NULL,
  `REPETICAO3` double(18,8) NOT NULL,
  `REPETICAO4` double(18,8) NOT NULL,
  `REPETICAO5` double(18,8) NOT NULL,
  `REPETICAO6` double(18,8) NOT NULL,
  `REPETICAO7` double(18,8) NOT NULL,
  `REPETICAO8` double(18,8) NOT NULL,
  `REPETICAO9` double(18,8) NOT NULL,
  `REPETICAO10` double(18,8) NOT NULL,
  `REPETICAO11` double(18,8) NOT NULL,
  `REPETICAO12` double(18,8) NOT NULL,
  `REPETICAO13` double(18,8) NOT NULL,
  `REPETICAO14` double(18,8) NOT NULL,
  `REPETICAO15` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoduplaface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoduplaface` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ESPESSURA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoespessuracliche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoespessuracliche` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ESPESSURA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexofaca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexofaca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOREFERENCIA` varchar(30) DEFAULT NULL,
  `DATAAQUISICAO` datetime DEFAULT NULL,
  `CODIGOFORNECEDOR` varchar(20) DEFAULT '',
  `NOMEFORNECEDOR` varchar(50) DEFAULT '',
  `LARGURA` double(18,8) NOT NULL,
  `ALTURA` double(18,8) NOT NULL,
  `DIAMETRO` double(18,8) NOT NULL,
  `LARGURAPAPEL` double(18,8) NOT NULL,
  `NUMERODENTESZ` double(18,8) NOT NULL,
  `NUMEROCARREIRAS` double(18,8) NOT NULL,
  `REPETICOES` double(18,8) NOT NULL,
  `TIRAGEMVIDAUTIL` double(18,8) NOT NULL,
  `VALORCUSTO` double(18,8) NOT NULL,
  `VALORCUSTOUSO` double(18,8) NOT NULL,
  `OBSERVACOES` longtext,
  `IMAGEMFACA` longblob,
  `LARGURAETIQUETA` double(18,8) DEFAULT NULL,
  `ALTURAETIQUETA` double(18,8) DEFAULT NULL,
  `CODIGOTIPOFACA` varchar(20) DEFAULT NULL,
  `DESATIVADO` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFornecedor` (`EMP_ID`,`CODIGOFORNECEDOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkTipoFaca` (`EMP_ID`,`CODIGOTIPOFACA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexofacamanutencao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexofacamanutencao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOFACA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `DATA` datetime DEFAULT NULL,
  `VALOR` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOFACA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoFaca` (`EMP_ID`,`CODIGOFACA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomaquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomaquina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` varchar(50) DEFAULT NULL,
  `FORMA` varchar(50) DEFAULT NULL,
  `TIRAGEM` int(11) NOT NULL DEFAULT '0',
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `NUMEROCORES` int(11) NOT NULL DEFAULT '0',
  `LARGURAMAXIMA` double(18,8) NOT NULL,
  `ALTURAMAXIMA` double(18,8) NOT NULL,
  `LARGURAMINIMA` double(18,8) NOT NULL,
  `ALTURAMINIMA` double(18,8) NOT NULL,
  `VALORHORAMAQUINA` double(18,8) NOT NULL,
  `VALORHORAOPERADOR` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `VALORACERTO` double(18,8) NOT NULL,
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `VALORLIMPEZA` double(18,8) NOT NULL,
  `TIPOACERTO` varchar(20) NOT NULL,
  `QTACERTOML` double(18,8) NOT NULL DEFAULT '0.00000000',
  `NUMEROCORESVERSO` int(11) NOT NULL,
  `APELIDO` varchar(50) NOT NULL,
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `ID_SCRIPT` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomaquinacliches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomaquinacliches` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOCLICHE` int(11) NOT NULL DEFAULT '0',
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTDPORTACLICHE` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOMAQUINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkFlexoCliche` (`EMP_ID`,`CODIGOCLICHE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomaquinamatprima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomaquinamatprima` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(20) DEFAULT '',
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTCONSUMO` double(18,8) NOT NULL,
  `QTCONSUMO2` double(18,8) NOT NULL,
  `QTMINIMACONSUMO` double(18,8) NOT NULL,
  `FOR_IDQUANT` int(11) DEFAULT '0',
  `FOR_IDVALOR` int(11) DEFAULT '0',
  `VALOR` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOMAQUINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquinaFlexo` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormulaQT` (`FOR_IDQUANT`),
  KEY `fkFormulaVlr` (`FOR_IDVALOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomaquinatinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomaquinatinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` varchar(20) NOT NULL DEFAULT '',
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PECFRENTE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `PECVERSO` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CODIGOMAQUINA`,`TIN_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkTinta` (`EMP_ID`,`TIN_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomaquinatipofaca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomaquinatipofaca` (
  `EMP_ID` int(11) NOT NULL,
  `CODIGOMAQUINA` varchar(20) NOT NULL,
  `CODIGOTIPOFACA` varchar(20) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOMAQUINA`,`CODIGOTIPOFACA`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkTipoFaca` (`EMP_ID`,`CODIGOTIPOFACA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomodelos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomodelos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `MOD_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAOMODELO` varchar(150) NOT NULL DEFAULT '',
  `ALTURAPICOTE` double(18,8) NOT NULL,
  `DESBOBINAMENTO` int(11) NOT NULL DEFAULT '0',
  `NUMEROPISTAS` int(11) DEFAULT NULL,
  `CODIGODUPLAFACE` int(11) DEFAULT NULL,
  `ESPESSURADUPLAFACE` double(18,8) DEFAULT NULL,
  `CODIGOESPESSURACLICHE` int(11) DEFAULT NULL,
  `ESPESSURACLICHE` double(18,8) DEFAULT NULL,
  `CODIGOPADRAOCORES` int(11) DEFAULT NULL,
  `DESCRICAOPADRAOCORES` varchar(50) DEFAULT NULL,
  `ORIGEMITEM` char(1) DEFAULT NULL,
  `CODIGOITEM` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoDuplaFace` (`EMP_ID`,`CODIGODUPLAFACE`),
  KEY `fkFlexoEspCliche` (`EMP_ID`,`CODIGOESPESSURACLICHE`),
  KEY `fkFlexoPadraoCores` (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`,`CODIGOPADRAOCORES`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomodelosimagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomodelosimagem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `MOD_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IMAGEM` longblob,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoModelo` (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexomodelospadraocores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexomodelospadraocores` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `MOD_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PANTONETINTA` varchar(100) NOT NULL DEFAULT '',
  `DESCRICAOANILOX` varchar(20) DEFAULT '',
  `BCMANILOX` varchar(20) DEFAULT '',
  `LINEATURAANILOX` varchar(20) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkModelo` (`EMP_ID`,`CODIGOORCAMENTO`,`MOD_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORC_DTORCAMENTO` datetime DEFAULT NULL,
  `CODIGOTIPOIMPRESSO` int(11) NOT NULL,
  `ORC_DTVALIDADEORC` datetime DEFAULT NULL,
  `CLI_ID` varchar(20) DEFAULT NULL,
  `CLI_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOENDERECO` int(11) DEFAULT NULL,
  `CLI_CIDADE` varchar(50) NOT NULL DEFAULT '',
  `CLI_UF` char(2) NOT NULL DEFAULT '',
  `CODIGOCONTATO` int(11) DEFAULT NULL,
  `CLI_RESPONSAVEL` varchar(50) NOT NULL DEFAULT '',
  `CLI_FONE` varchar(20) NOT NULL DEFAULT '',
  `tipoimposto` varchar(20) NOT NULL DEFAULT '0',
  `ORC_DESCRICAO` longtext NOT NULL,
  `VEN_ID` varchar(20) DEFAULT NULL,
  `UNIDADEORCAMENTO` varchar(50) DEFAULT NULL,
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOFORMAPAGAMENTO` varchar(50) NOT NULL DEFAULT '',
  `PERCFORMAPAGAMENTO` double(18,8) NOT NULL,
  `LARGURA` double(18,8) NOT NULL,
  `ALTURA` double(18,8) NOT NULL,
  `DIAMETROTUBETE` double(18,8) NOT NULL,
  `ACABROLOSETIQUETAS` int(11) NOT NULL DEFAULT '0',
  `ACABROLOSMETROS` double(18,8) NOT NULL,
  `ACABCORTADAETIQUETAS` int(11) NOT NULL DEFAULT '0',
  `ACABENFESTADO` int(11) NOT NULL DEFAULT '0',
  `ACABENFESTADOETIQUETAS` int(11) NOT NULL DEFAULT '0',
  `ACABENFESTADOETIQUETASCAIXAS` int(11) NOT NULL DEFAULT '0',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `ORC_PROPOSTA` char(1) NOT NULL DEFAULT '',
  `ORC_ORDEMSERVICO` char(1) NOT NULL DEFAULT '',
  `ORC_VLRCUSTO` double(18,8) NOT NULL,
  `NUMEROCONTRATO` varchar(20) DEFAULT NULL,
  `OBSERVACAOPOSCALCULO` longtext,
  `QTDUNIDADEORCAMENTO` double(18,8) DEFAULT '0.00000000',
  `CODPERFILIMPOSTO` int(11) NOT NULL,
  `BASECALCPAPEL` varchar(50) NOT NULL,
  `GERADESCRICAOAUT` char(1) NOT NULL,
  `CST` varchar(5) DEFAULT NULL,
  `CODIGONCM` varchar(20) DEFAULT NULL,
  `CSTIPI` varchar(20) DEFAULT NULL,
  `CSTPIS` varchar(20) DEFAULT NULL,
  `CSTCOFINS` varchar(20) DEFAULT NULL,
  `CNAE` varchar(10) DEFAULT NULL,
  `ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `UNIDADECONSUMO` varchar(30) NOT NULL,
  `CREDITAPISCOFINS` char(1) DEFAULT NULL,
  `CREDITAICMSIPI` char(1) DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `COMISSAOMANUAL` char(50) NOT NULL,
  `ORC_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `ORC_TITULO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `fkEndereco` (`EMP_ID`,`CLI_ID`,`CODIGOENDERECO`),
  KEY `fkContato` (`EMP_ID`,`CLI_ID`,`CODIGOCONTATO`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkPerfilImposto` (`EMP_ID`,`CODPERFILIMPOSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcimpostos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcimpostos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCICMS` double(18,8) NOT NULL,
  `PERCIPI` double(18,8) NOT NULL,
  `PERCISS` double(18,8) NOT NULL,
  `PERCPIS` double(18,8) NOT NULL,
  `PERCCOFINS` double(18,8) NOT NULL,
  `PERCSIMPLESFEDERAL` double(18,8) NOT NULL,
  `PERCSIMPLESESTADUAL` double(18,8) NOT NULL,
  `PERCIR` double(18,8) NOT NULL,
  `PERCCSLL` double(18,8) NOT NULL,
  `PERCTXADM` double(18,8) NOT NULL,
  `PERCOUTROS` double(18,8) NOT NULL,
  `DEFINIRMANUAL` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclamacabqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclamacabqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTACERTO` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADE` double(18,8) NOT NULL,
  `MONTAGEM` double(18,8) NOT NULL,
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `VALORMAQUINAOPERADOR` double(18,8) NOT NULL,
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `VALORACERTO` double(18,8) NOT NULL,
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `VALORLIMPEZA` double(18,8) NOT NULL,
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `TIRAGEMMAQUINA` int(11) NOT NULL DEFAULT '0',
  `TIRAGEMCALCULADA` int(11) NOT NULL DEFAULT '0',
  `TEMPOACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `VALORACABAMENTO` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoQtde` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclamina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclamina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOLAMINA` varchar(50) DEFAULT NULL,
  `FATORX` int(11) NOT NULL DEFAULT '0',
  `CORFRENTE` int(11) NOT NULL DEFAULT '0',
  `CORVERSO` int(11) NOT NULL DEFAULT '0',
  `TOTALCORES` int(11) NOT NULL DEFAULT '0',
  `COBRAACERTO` int(11) NOT NULL DEFAULT '0',
  `COBRALAVAGEM` int(11) NOT NULL DEFAULT '0',
  `ACERTOADICIONAL` int(11) NOT NULL DEFAULT '0',
  `LAVAGEMADICIONAL` int(11) NOT NULL DEFAULT '0',
  `BOBINALARGURA` double(18,8) NOT NULL,
  `BOBINAALTURA` double(18,8) NOT NULL,
  `BOBINACORTE` double(18,8) NOT NULL,
  `BOBINAPRECO2` double(18,8) NOT NULL,
  `MEDFINALLARGURA` double(18,8) NOT NULL,
  `MEDFINALALTURA` double(18,8) NOT NULL,
  `CARREIRA` double(18,8) NOT NULL,
  `REPETICAO` double(18,8) NOT NULL,
  `ESPACOABA` double(18,8) NOT NULL,
  `COLUNAVERTICAL` double(18,8) NOT NULL,
  `COLUNADIAGONAL` double(18,8) NOT NULL,
  `NUMERODENTESZ` double(18,8) NOT NULL,
  `CODIGOCLICHE` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOMAQUINA` varchar(50) NOT NULL DEFAULT '',
  `TIRAGEMMAQUINA` int(11) NOT NULL DEFAULT '0',
  `VALORHORAMAQUINA` double(18,8) NOT NULL,
  `VALORHORAOPERADOR` double(18,8) NOT NULL,
  `VALORACERTO` double(18,8) NOT NULL,
  `VALORLIMPEZA` double(18,8) NOT NULL,
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `NUMEROCORES` int(11) NOT NULL DEFAULT '0',
  `CODIGOFACAPRINCIPAL` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOFACA` varchar(50) NOT NULL DEFAULT '0',
  `VALORFACAPRINCIPAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QUANTIDADEPAPELACERTOML` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TIPOACERTO` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoCliche` (`EMP_ID`,`CODIGOCLICHE`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkFlexoFacaPrinc` (`EMP_ID`,`CODIGOFACAPRINCIPAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclaminabobina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclaminabobina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PRINCIPAL` int(11) NOT NULL DEFAULT '0',
  `VALOR` double(18,8) NOT NULL,
  `FATORABSORCAO` double(18,8) NOT NULL,
  `LARGURA` double(18,8) NOT NULL,
  `PRECO` double(18,8) NOT NULL,
  `PERCPERDA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ARREDONDAMENTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclaminabobinaqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclaminabobinaqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PRINCIPAL` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADEPAPELML` double(18,8) NOT NULL,
  `QUANTIDADEPAPELM2` double(18,8) NOT NULL,
  `QUANTIDADEPAPELIMPRESSAOML` double(18,8) NOT NULL,
  `QUANTIDADEPAPELPERDAML` double(18,8) NOT NULL,
  `QUANTIDADEPAPELACERTOML` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `FATORABSORCAO` double(18,8) NOT NULL,
  `LARGURA` double(18,8) NOT NULL,
  `PRECO` double(18,8) NOT NULL,
  `QUANTIDADEPAPELARREDML` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`,`CODIGO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoQtde` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclaminafaca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclaminafaca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclaminatinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclaminatinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PERCAREAFRENTE` double(18,8) NOT NULL,
  `PERCAREAVERSO` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `FATORABSORCAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclaminatintaqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclaminatintaqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PERCAREAFRENTE` double(18,8) NOT NULL,
  `PERCAREAVERSO` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `QTTINTA` double(18,8) NOT NULL,
  `VALORTINTA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoQtde` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclamqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclamqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `TIPOLAMINA` varchar(50) DEFAULT NULL,
  `CARREIRA` double(18,8) NOT NULL,
  `MEDFINALALTURA` double(18,8) NOT NULL,
  `COLUNADIAGONAL` double(18,8) NOT NULL,
  `PAPELML` double(18,8) NOT NULL,
  `PAPELMLIMPRESSAO` double(18,8) NOT NULL,
  `PAPELMLACERTO` double(18,8) NOT NULL,
  `PAPELMLPERDA` double(18,8) NOT NULL,
  `PAPELMLVALOR` double(18,8) NOT NULL,
  `BOBINAPRECO2` double(18,8) NOT NULL,
  `COEFCORES` int(11) NOT NULL DEFAULT '0',
  `CORFRENTE` int(11) NOT NULL DEFAULT '0',
  `CORVERSO` int(11) NOT NULL DEFAULT '0',
  `TOTALCORES` int(11) NOT NULL DEFAULT '0',
  `TIRAGEM` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOMAQUINA` varchar(50) NOT NULL DEFAULT '',
  `TIRAGEMMAQUINA` int(11) NOT NULL DEFAULT '0',
  `VALORHORAMAQUINA` double(18,8) NOT NULL,
  `VALORHORAOPERADOR` double(18,8) NOT NULL,
  `VALORACERTO` double(18,8) NOT NULL,
  `VALORLIMPEZA` double(18,8) NOT NULL,
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `NUMEROCORES` int(11) NOT NULL DEFAULT '0',
  `TEMPOIMPRESSAO` int(11) NOT NULL DEFAULT '0',
  `VALORIMPRESSAO` double(18,8) NOT NULL,
  `LAVAGEMADICIONAL` int(11) NOT NULL DEFAULT '0',
  `QTLAVACAO` int(11) NOT NULL DEFAULT '0',
  `TEMPOTOTALLAVACAO` int(11) NOT NULL DEFAULT '0',
  `VALORTOTALLAVACAO` double(18,8) NOT NULL,
  `ACERTOADICIONAL` int(11) NOT NULL DEFAULT '0',
  `QTACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOTOTALACERTO` int(11) NOT NULL DEFAULT '0',
  `VALORTOTALACERTO` double(18,8) NOT NULL,
  `VALORTOTALFACAS` double(18,8) NOT NULL,
  `VALORTOTALACABAMENTOS` double(18,8) NOT NULL,
  `VALORTOTALSERVICOS` double(18,8) NOT NULL,
  `VALORTOTALSERVICOSINTERNOS` double(18,8) NOT NULL,
  `VALORTOTALTINTAS` double(18,8) NOT NULL,
  `QUANTIDADEETIQUETAS` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoQuantidade` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorclamservicoqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorclamservicoqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORMINIMO` double(18,8) NOT NULL,
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIPOSERVICO` varchar(50) DEFAULT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `ID_FORMULA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoQtde` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOQUANTIDADE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkFormula` (`ID_FORMULA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcmaqacabamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcmaqacabamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTACERTO` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADE` double(18,8) NOT NULL,
  `MONTAGEM` double(18,8) NOT NULL,
  `VALORMAQUINA` double(18,8) NOT NULL,
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIRAGEMMAQUINA` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcmaqacabamentomatprima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcmaqacabamentomatprima` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(30) NOT NULL,
  `FOR_IDQUANT` int(11) NOT NULL,
  `FOR_IDVALOR` int(11) NOT NULL,
  `QTCONSUMO` double NOT NULL,
  `QTCONSUMO2` double NOT NULL,
  `QTMINIMACONSUMO` double NOT NULL,
  `VALORUNITARIO` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOACABAMENTO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOACABAMENTO`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormulaQT` (`FOR_IDQUANT`),
  KEY `fkFormulaValor` (`FOR_IDVALOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcmaqacabamentomatprimaqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcmaqacabamentomatprimaqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `CODIGOQUANTIDADE` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORTOTAL` double NOT NULL,
  `QUANTIDADETOTAL` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGOACABAMENTO`,`CODIGO`,`CODIGOQUANTIDADE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOACABAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcmtdiverso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcmtdiverso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MTDIV_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTDIV_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `MTDIV_UNCONSUMO` varchar(10) NOT NULL DEFAULT '',
  `MTR_PRECOCUSTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MTDIV_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcmtdiversoqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcmtdiversoqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `MTDIV_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTDIV_QT` double(18,8) NOT NULL,
  `MTDIV_PRECOCUSTO` double(18,8) NOT NULL,
  `MTDIV_PRECOTOTAL` double(18,8) NOT NULL,
  `MTDIV_QTORCAMENTO` int(11) NOT NULL DEFAULT '0',
  `MTDIV_MONTAGEM` double(18,8) NOT NULL,
  `MTDIV_QTCALCULADA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`QTO_ID`,`MTDIV_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkFlexoMatDiverso` (`EMP_ID`,`ORC_ID`,`MTDIV_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcobservacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcobservacoes` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OBSERVACAO` longtext,
  `OBSERVACAOADICIONAL` longtext,
  `OBSERVACAOINTERNA` longtext,
  `COPIAROBSOP` char(1) DEFAULT NULL,
  `COPIAROBSADICIONALOP` char(1) DEFAULT NULL,
  `COPIAROBSINTERNAOP` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcprodutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcprodutor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PRO_PERCCOMISSAO` double(18,8) NOT NULL,
  `NOMEPRODUTOR` varchar(50) NOT NULL,
  `PES_IDPAIAGENCIA` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkProdutor` (`EMP_ID`,`PES_ID`),
  KEY `fkAgencia` (`EMP_ID`,`PES_IDPAIAGENCIA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcquantidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcquantidade` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADECOMERCIAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORCUSTO` double(18,8) NOT NULL,
  `PERCMARGEMLUCRO` double(18,8) NOT NULL,
  `VALORMARGEMLUCRO` double(18,8) NOT NULL,
  `PERCCONTRIBMARGINAL` double(18,8) NOT NULL,
  `VALORCONTRIBMARGINAL` double(18,8) NOT NULL,
  `VALORCONTRIBMARGINALSEMLUCRO` double(18,8) NOT NULL,
  `PERCCOMVENDEDOR` double(18,8) NOT NULL,
  `VALORCOMVENDEDOR` double(18,8) NOT NULL,
  `PERCCOMAGENCIA` double(18,8) NOT NULL,
  `VALORCOMAGENCIA` double(18,8) NOT NULL,
  `PERCIMPOSTOS` double(18,8) NOT NULL,
  `VALORIMPOSTOS` double(18,8) NOT NULL,
  `VALORUNITVISTA` double(18,8) NOT NULL,
  `VALORTOTALVISTA` double(18,8) NOT NULL,
  `VALORUNITPRAZO` double(18,8) NOT NULL,
  `VALORTOTALPRAZO` double(18,8) NOT NULL,
  `VALORTOTACERTOIMP` double(18,8) NOT NULL,
  `TEMPOTOTACERTOIMP` int(11) NOT NULL DEFAULT '0',
  `VALORTOTLIMPEZAIMP` double(18,8) NOT NULL,
  `TEMPOTOTLIMPEZAIMP` int(11) NOT NULL DEFAULT '0',
  `VALORTOTIMPRESSAO` double(18,8) NOT NULL,
  `TEMPOTOTIMPRESSAO` int(11) NOT NULL DEFAULT '0',
  `VALORTOTPAPELML` double(18,8) NOT NULL,
  `QTTOTPAPELML` double(18,8) NOT NULL,
  `QTTOTPAPELIMPRESSAOML` double(18,8) NOT NULL,
  `QTTOTPAPELACERTOML` double(18,8) NOT NULL,
  `QTTOTPAPELPERDAML` double(18,8) NOT NULL,
  `VALORTOTACERTOACAB` double(18,8) NOT NULL,
  `TEMPOTOTACERTOACAB` int(11) NOT NULL DEFAULT '0',
  `VALORTOTLIMPEZAACAB` double(18,8) NOT NULL,
  `TEMPOTOTLIMPEZAACAB` int(11) NOT NULL DEFAULT '0',
  `VALORTOTACABAMENTO` double(18,8) NOT NULL,
  `TEMPOTOTACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `QTTOTSERVICOS` double(18,8) NOT NULL,
  `VALORTOTSERVICOS` double(18,8) NOT NULL,
  `QTTOTFACAS` double(18,8) NOT NULL,
  `VALORTOTFACAS` double(18,8) NOT NULL,
  `QTTOTTINTAS` double(18,8) NOT NULL,
  `VALORTOTTINTAS` double(18,8) NOT NULL,
  `VALORUNITCOMERCIAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `VALORUNITVISTACOMERCIAL` double(18,8) NOT NULL,
  `QTTOTALMATERIAISDIV` double(18,8) NOT NULL,
  `VALORTOTALMATERIAISDIV` double(18,8) NOT NULL,
  `QTTOTALMATDIVACAB` double(18,8) NOT NULL,
  `VALORTOTALMATDIVACAB` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOLAMINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORMINIMO` double(18,8) NOT NULL,
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIPOSERVICO` varchar(50) DEFAULT NULL,
  `ID_FORMULA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoLamina` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOLAMINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkFormula` (`ID_FORMULA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoorcvendedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoorcvendedores` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEVENDEDOR` varchar(50) NOT NULL DEFAULT '',
  `PERCCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrcamento` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexopadraocores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexopadraocores` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexoservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexoservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORMINIMO` double(18,8) NOT NULL,
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIPOSERVICO` varchar(50) DEFAULT NULL,
  `ID_FORMULA` int(11) DEFAULT NULL,
  `APELIDO` varchar(50) NOT NULL,
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `ID_SCRIPT` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkFormula` (`ID_FORMULA`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipofaca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipofaca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TF_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TF_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TF_DESATIVADO` char(1) DEFAULT 'N' COMMENT 'Desativado',
  PRIMARY KEY (`EMP_ID`,`TF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipoimpresso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipoimpresso` (
  `EMP_ID` int(11) NOT NULL,
  `CODIGOTIPOIMPRESSO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` longtext NOT NULL,
  `OBSERVACOES` longtext,
  `COPIAROBSORC` char(1) NOT NULL,
  `UNIDADECONSUMO` varchar(30) NOT NULL,
  `CODPERFILIMPOSTO` int(11) NOT NULL,
  `BASECALCPAPEL` varchar(50) NOT NULL,
  `DESATIVADO` char(1) NOT NULL,
  `CST` varchar(5) DEFAULT NULL,
  `CODIGONCM` varchar(20) DEFAULT NULL,
  `CSTIPI` varchar(20) DEFAULT NULL,
  `CSTPIS` varchar(20) DEFAULT NULL,
  `CSTCOFINS` varchar(20) DEFAULT NULL,
  `CNAE` varchar(10) DEFAULT NULL,
  `ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `CREDITAICMSIPI` char(1) DEFAULT NULL,
  `CREDITAPISCOFINS` char(1) DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `TPI_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `TPI_PERCMARGEMLUCRO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOIMPRESSO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipoimpressocomponente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipoimpressocomponente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOIMPRESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOLAMINA` varchar(50) DEFAULT NULL,
  `FATORX` int(11) NOT NULL DEFAULT '0',
  `CORFRENTE` int(11) NOT NULL DEFAULT '0',
  `CORVERSO` int(11) NOT NULL DEFAULT '0',
  `TOTALCORES` int(11) NOT NULL DEFAULT '0',
  `COBRAACERTO` char(1) NOT NULL DEFAULT '0',
  `COBRALAVAGEM` char(1) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` int(11) NOT NULL DEFAULT '0',
  `CODIGOFACAPRINCIPAL` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `fkFlexoFacaPrinc` (`EMP_ID`,`CODIGOFACAPRINCIPAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipoimpressocomponenteacab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipoimpressocomponenteacab` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOIMPRESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGOCOMPONENTE`,`CODIGOMAQUINA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpressoComp` (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGOCOMPONENTE`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipoimpressocomponenteacabmatprima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipoimpressocomponenteacabmatprima` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOIMPRESSO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQUINA` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(30) NOT NULL,
  `FOR_IDQUANT` int(11) NOT NULL,
  `FOR_IDVALOR` int(11) NOT NULL,
  `QTCONSUMO` double NOT NULL,
  `QTCONSUMO2` double NOT NULL,
  `QTMINIMACONSUMO` double NOT NULL,
  `VALORUNITARIO` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGOCOMPONENTE`,`CODIGOMAQUINA`,`CODIGO`),
  KEY `fkMateriaPrima` (`EMP_ID`,`MTR_ID`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUINA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flexotipoimpressocomponenteservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flexotipoimpressocomponenteservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOIMPRESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOSERVICO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGOCOMPONENTE`,`CODIGOSERVICO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`CODIGOTIPOIMPRESSO`),
  KEY `fkTipoImpressoComp` (`EMP_ID`,`CODIGOTIPOIMPRESSO`,`CODIGOCOMPONENTE`),
  KEY `fkFlexoServico` (`EMP_ID`,`CODIGOSERVICO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formapagto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formapagto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOP_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `FOP_TIPOPAGTO` varchar(20) NOT NULL DEFAULT '',
  `FOP_CTAPRIMEIRAPARC` varchar(20) DEFAULT NULL,
  `FOP_CTADEMAISPARC` varchar(20) DEFAULT NULL,
  `FOP_PERCJUROS` double(18,8) NOT NULL,
  `FOP_PARCELASIGUAIS` char(1) NOT NULL DEFAULT '',
  `FOP_VENCTOMESMODIA` char(1) NOT NULL DEFAULT '',
  `FOP_COMENTRADA` char(1) NOT NULL DEFAULT '',
  `FOP_NRODIAS` int(11) NOT NULL DEFAULT '0',
  `FOP_TIPODIASVENCIMENTO` varchar(20) NOT NULL DEFAULT '0',
  `FOP_DIASSEMANA` longtext,
  `FOP_DIASESPECIFICOS` longtext,
  `FOP_INICIARCONTAGEMPROXMES` char(1) NOT NULL,
  `FOP_TIPOOPERACAO` varchar(30) NOT NULL,
  `FOP_DESATIVADO` char(1) NOT NULL,
  `FOP_TIPOPRAZO` varchar(20) NOT NULL,
  `IDTIPODOCUMENTOFINANCEIRO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`FOP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fk_formapagto_tipodocumentofinanceiro` (`IDTIPODOCUMENTOFINANCEIRO`),
  CONSTRAINT `fk_formapagto_tipodocumentofinanceiro` FOREIGN KEY (`IDTIPODOCUMENTOFINANCEIRO`) REFERENCES `tipodocumentofinanceiro` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formapagtoparcela`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formapagtoparcela` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `FPP_NROPARCELA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FPP_QTDIAS` int(11) NOT NULL DEFAULT '0',
  `FPP_PERCPARCELA` double(18,8) NOT NULL,
  `FPP_DATAFIXA` date DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`FOP_ID`,`FPP_NROPARCELA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formasdespachoencomendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formasdespachoencomendas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FDE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FDE_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `FDE_TIPO` varchar(20) NOT NULL DEFAULT '',
  `FDE_TIPOCORREIO` varchar(20) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`FDE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formatoimp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formatoimp` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `FIM_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDP_ID` varchar(20) NOT NULL DEFAULT '',
  `FIM_MEDLARGURA` double(18,8) NOT NULL,
  `FIM_MEDALTURA` double(18,8) NOT NULL,
  `FIM_FORMATO` int(11) NOT NULL DEFAULT '0',
  `FIM_PERCPERDA` double(18,8) NOT NULL,
  `FIM_FORMATOALTERADO` char(1) NOT NULL DEFAULT '',
  `FIM_DEFFORMPERMANUAL` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`FIM_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMedidaPapel` (`EMP_ID`,`MDP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `formula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formula` (
  `FOR_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOR_DESCRICAO` varchar(50) DEFAULT NULL,
  `FOR_FORMULA` longtext,
  `FOR_CONJUNTOFORMULAS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`FOR_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOP_ID` varchar(20) DEFAULT NULL,
  `ATI_ID` varchar(20) DEFAULT NULL,
  `PCO_ID` int(11) NOT NULL DEFAULT '0',
  `FORNECEDORDIRETO` char(1) NOT NULL DEFAULT 'S',
  `FOR_TIPOTRIBUTACAO` varchar(20) DEFAULT NULL,
  `FOR_SUBSTITUTOTRIBUTARIO` char(1) DEFAULT NULL,
  `PCO_IDPASSIVO` int(11) NOT NULL DEFAULT '0',
  `FOR_INTERMEDIADOR` char(1) NOT NULL DEFAULT 'N',
  `FOR_INSTITUICAOPAGAMENTO` char(1) NOT NULL DEFAULT 'N',
  `OPERADORA` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkAtividade` (`EMP_ID`,`ATI_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`PCO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fornecedorprodutos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedorprodutos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PROD_ORIGEM` varchar(50) NOT NULL DEFAULT '',
  `PROD_IDWINGRAPH` varchar(20) NOT NULL DEFAULT '',
  `PROD_IDFORNECEDOR` varchar(50) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRU_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GRU_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`GRU_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupocliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupocliente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRC_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GRC_DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`GRC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoconta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoconta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `NATUREZA` varchar(20) NOT NULL DEFAULT '',
  `CONTAREDUTORA` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoimpmaquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoimpmaquina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GI_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`GI_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoimpressao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoimpressao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GI_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GI_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `GI_DESATIVADO` char(1) DEFAULT 'N' COMMENT 'Desativado',
  `GI_UTILIZARLISTAPRECO` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`GI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoorcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoorcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRO_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GRO_DESCRICAO` longtext NOT NULL,
  `GRO_QTDTOTAL` double(18,8) NOT NULL,
  `GRO_VLRUNITTOTAL` double(18,8) NOT NULL,
  `GRO_VLRTOTAL` double(18,8) NOT NULL,
  `GRO_CODIGOCLENTE` varchar(20) NOT NULL,
  `GRO_CODIGOVENDEDOR` varchar(20) NOT NULL,
  `GRO_UFCLIENTE` char(2) NOT NULL,
  `GRO_CODIGOFORMAPAGTO` varchar(20) NOT NULL,
  `GRO_SALDO` double(18,8) NOT NULL,
  `GRO_OPGERADA` char(1) NOT NULL,
  `GRO_CLASSIFICACAO` varchar(20) NOT NULL,
  `GRO_PROPOSTAGERADA` char(1) NOT NULL,
  `GRO_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `GRO_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `GRO_CODIGOENDERECO` int(11) DEFAULT NULL,
  `GRO_CODIGOCONTATO` int(11) DEFAULT NULL,
  `GRO_FONECLI` varchar(12) NOT NULL,
  `GRO_DESMEMBRAR` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`GRO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`GRO_CODIGOCLENTE`),
  KEY `fkVendedor` (`EMP_ID`,`GRO_CODIGOVENDEDOR`),
  KEY `fkFormaPagto` (`EMP_ID`,`GRO_CODIGOFORMAPAGTO`),
  KEY `fkEndereco` (`EMP_ID`,`GRO_CODIGOCLENTE`,`GRO_CODIGOENDERECO`),
  KEY `fkContato` (`EMP_ID`,`GRO_CODIGOCLENTE`,`GRO_CODIGOCONTATO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoorcamentoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoorcamentoitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRO_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORC_DESCRICAO` longtext NOT NULL,
  `ORC_QTD` double(18,8) NOT NULL,
  `ORC_VLRUNITPRAZO` double(18,8) NOT NULL,
  `ORC_VLRFINALPRAZO` double(18,8) NOT NULL,
  `ORS_ID` varchar(20) DEFAULT NULL,
  `PROP_ID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`GRO_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkGrupoOrc` (`EMP_ID`,`GRO_ID`),
  KEY `fkOP` (`EMP_ID`,`ORS_ID`),
  KEY `fkProposta` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `grupoprodutofsc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoprodutofsc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GRP_DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`GRP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `historicodespesas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historicodespesas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOMAPA` int(11) NOT NULL DEFAULT '0',
  `MES` int(11) NOT NULL DEFAULT '0',
  `ANO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TOTALDESPESAS` double(18,8) NOT NULL,
  `CODIGOCONTABIL` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOREDUZIDO`,`CODIGOTIPOMAPA`,`MES`,`ANO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOREDUZIDO`),
  KEY `fkTipoMapa` (`EMP_ID`,`CODIGOTIPOMAPA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `historicoequipamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historicoequipamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOEQUIPAMENTO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOMAPA` int(11) NOT NULL DEFAULT '0',
  `MES` int(11) NOT NULL DEFAULT '0',
  `ANO` int(11) NOT NULL DEFAULT '0',
  `HORASUTILIZADAS` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOEQUIPAMENTO`,`CODIGOTIPOMAPA`,`MES`,`ANO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEquipamento` (`EMP_ID`,`CODIGOEQUIPAMENTO`),
  KEY `fkTipoMapa` (`EMP_ID`,`CODIGOTIPOMAPA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `historicosalarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historicosalarios` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOFUNC` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOMAPA` int(11) NOT NULL DEFAULT '0',
  `MES` int(11) NOT NULL DEFAULT '0',
  `ANO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORSALARIO` double(18,8) NOT NULL,
  `ADICIONAISSAL` double(18,8) NOT NULL,
  `HOREXTRASMES` double(18,8) NOT NULL,
  `HORASTRABMES` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOFUNC`,`CODIGOTIPOMAPA`,`MES`,`ANO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFuncionario` (`EMP_ID`,`CODIGOFUNC`),
  KEY `fkTipoMapa` (`EMP_ID`,`CODIGOTIPOMAPA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ibpt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ibpt` (
  `IBPT_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CODIGO` varchar(15) NOT NULL DEFAULT '0',
  `TIPO` char(1) NOT NULL DEFAULT '',
  `UF` char(2) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ALIQ_NACIONALFED` double(18,8) DEFAULT NULL,
  `ALIQ_IMPORTADOSFED` double(18,8) DEFAULT NULL,
  `ALIQ_ESTADUAL` double(18,8) DEFAULT NULL,
  `ALIQ_MUNICIPAL` double(18,8) DEFAULT NULL,
  `VALIDADE` date DEFAULT NULL,
  `CHAVE` varchar(10) DEFAULT NULL,
  `FONTE` varchar(10) DEFAULT NULL,
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`IBPT_ID`,`CODIGO`,`TIPO`,`UF`),
  KEY `ak_CodigoIBPT` (`CODIGO`,`TIPO`,`UF`)
) ENGINE=InnoDB AUTO_INCREMENT=12496 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `identificadorcusto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `identificadorcusto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDENT_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`IDENT_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `identificadorordemproducao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `identificadorordemproducao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDENT_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(80) NOT NULL DEFAULT '',
  `TIPO` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`IDENT_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `iestragopapel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iestragopapel` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IEP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IEP_TIRAGEM` int(11) NOT NULL DEFAULT '0',
  `IEP_GRAMUM_EUM` double(18,8) NOT NULL,
  `IEP_GRAMUM_EDOIS` double(18,8) NOT NULL,
  `IEP_GRAMUM_ETRES` double(18,8) NOT NULL,
  `IEP_GRAMUM_EQUATRO` double(18,8) NOT NULL,
  `IEP_GRAMUM_ECINCO` double(18,8) NOT NULL,
  `IEP_GRAMDOIS_EUM` double(18,8) NOT NULL,
  `IEP_GRAMDOIS_EDOIS` double(18,8) NOT NULL,
  `IEP_GRAMDOIS_ETRES` double(18,8) NOT NULL,
  `IEP_GRAMDOIS_EQUATRO` double(18,8) NOT NULL,
  `IEP_GRAMDOIS_ECINCO` double(18,8) NOT NULL,
  `IEP_GRAMTRES_EUM` double(18,8) NOT NULL,
  `IEP_GRAMTRES_EDOIS` double(18,8) NOT NULL,
  `IEP_GRAMTRES_ETRES` double(18,8) NOT NULL,
  `IEP_GRAMTRES_EQUATRO` double(18,8) NOT NULL,
  `IEP_GRAMTRES_ECINCO` double(18,8) NOT NULL,
  `IEP_GRAMQUATRO_EUM` double(18,8) NOT NULL,
  `IEP_GRAMQUATRO_EDOIS` double(18,8) NOT NULL,
  `IEP_GRAMQUATRO_ETRES` double(18,8) NOT NULL,
  `IEP_GRAMQUATRO_EQUATRO` double(18,8) NOT NULL,
  `IEP_GRAMQUATRO_ECINCO` double(18,8) NOT NULL,
  `IEP_GRAMCINCO_EUM` double(18,8) NOT NULL,
  `IEP_GRAMCINCO_EDOIS` double(18,8) NOT NULL,
  `IEP_GRAMCINCO_ETRES` double(18,8) NOT NULL,
  `IEP_GRAMCINCO_EQUATRO` double(18,8) NOT NULL,
  `IEP_GRAMCINCO_ECINCO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`IEP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `imposto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imposto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PER_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IMP_ISS` double(18,8) NOT NULL,
  `IMP_PIS` double(18,8) NOT NULL,
  `IMP_OUTROS` double(18,8) NOT NULL,
  `IMP_COFINS` double(18,8) NOT NULL,
  `IMP_TAXADMIN` double(18,8) NOT NULL,
  `IMP_IMPRENDA` double(18,8) NOT NULL,
  `IMP_SIMPLESFEDERAL` double(18,8) NOT NULL,
  `IMP_SIMPLESESTADUAL` double(18,8) NOT NULL,
  `IMP_CSLL` double(18,8) NOT NULL,
  `IMP_IPI` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`PER_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `impostoestado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impostoestado` (
  `EMP_ID` int(11) NOT NULL,
  `PER_ID` int(11) NOT NULL,
  `EST_SIGLA` char(2) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EST_PERCICMS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EST_PERCICMSST` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EST_PERCICMSINTIMPORTADO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EST_PERCICMSINTRA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EST_PERCICMSINTER` double(18,8) NOT NULL DEFAULT '0.00000000',
  `EST_PERCFCP` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`PER_ID`,`EST_SIGLA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkImposto` (`EMP_ID`,`PER_ID`),
  KEY `fkEstado` (`EST_SIGLA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `impostoperfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impostoperfil` (
  `EMP_ID` int(10) NOT NULL DEFAULT '0',
  `PER_ID` int(10) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PER_DESCRICAO` varchar(32) NOT NULL DEFAULT '',
  `PER_CLASSIFICACAO` varchar(20) NOT NULL,
  `PER_PADRAO` char(1) NOT NULL,
  PRIMARY KEY (`PER_ID`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkImposto` (`EMP_ID`,`PER_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integracaoimportacaocampo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracaoimportacaocampo` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_INTEGRACAOTABELA` int(11) NOT NULL DEFAULT '0',
  `ID_ITEM` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMECAMPOWINGRAPH` varchar(50) NOT NULL,
  `ENTIDADE` varchar(100) NOT NULL,
  `CAMPO` varchar(100) NOT NULL,
  `CAMINHO` varchar(100) NOT NULL,
  `RELACIONAMENTO` varchar(100) NOT NULL,
  `VALORDEFAULT` varchar(150) DEFAULT NULL,
  `PK` char(1) NOT NULL,
  `LOCALIZADOR` char(1) NOT NULL,
  `CALCULADO` char(1) NOT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_ITEM`,`ID_INTEGRACAOTABELA`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integracaoimportacaotabela`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracaoimportacaotabela` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_INTEGRACAOTABELA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SEQUENCIALEXECUCAO` int(11) NOT NULL,
  `NOMETABELAWINGRAPH` varchar(50) NOT NULL,
  `FORMAMANUTENCAO` varchar(30) NOT NULL,
  `CARDINALIDADE` varchar(30) DEFAULT NULL,
  `ID_TABELARELACIONADA` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_INTEGRACAOTABELA`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integracaoimportacaoxml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracaoimportacaoxml` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_ITEM` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ENTIDADE` varchar(100) NOT NULL,
  `CAMPO` varchar(100) NOT NULL,
  `CAMINHO` varchar(100) NOT NULL,
  `RELACIONAMENTO` varchar(100) NOT NULL,
  `PK` char(1) NOT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_ITEM`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integracaoperfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracaoperfil` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `DESATIVADO` char(1) NOT NULL DEFAULT '',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `FORMATO` varchar(20) NOT NULL DEFAULT '',
  `MODELOORIGEM` longtext NOT NULL,
  `ORIGEMDESTINO` varchar(20) NOT NULL,
  `STATUSCOMUNICACAO` varchar(100) DEFAULT NULL COMMENT 'Status de cominicação do perfil',
  `TOKENAUTORIZACAO` varchar(150) DEFAULT NULL,
  `SALESFORCE_OBTEMTOKEN` varchar(100) DEFAULT NULL,
  `SALESFORCE_CLIENTID` varchar(100) DEFAULT NULL,
  `SALESFORCE_CLIENTSECRET` varchar(100) DEFAULT NULL,
  `SALESFORCE_USERNAME` varchar(100) DEFAULT NULL,
  `SALESFORCE_PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integracaoperfilconfiguracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integracaoperfilconfiguracao` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOPRODUTOR` varchar(30) DEFAULT NULL,
  `PASTALOCAL` varchar(100) DEFAULT NULL,
  `NUMEROCONTROLE` varchar(100) DEFAULT NULL,
  `TIPOPROCESSAMENTOADICIONAL` varchar(30) DEFAULT NULL,
  `PER_ID` int(11) DEFAULT NULL,
  `DELIMITERCSVESQUERDA` char(1) DEFAULT NULL,
  `DELIMITERCSVDIREITA` char(1) DEFAULT NULL,
  `MASCARAGERARARQUIVO` varchar(100) DEFAULT NULL,
  `TIPOPASTALOCAL` varchar(30) DEFAULT NULL,
  `LOCALARQUIVOEMAIL` varchar(30) DEFAULT NULL,
  `PASTADESTINOFTP` varchar(50) DEFAULT NULL,
  `IDCONTAEMAIL` int(11) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `FTP` varchar(100) DEFAULT NULL,
  `URLPRINCIPAL` varchar(300) DEFAULT NULL,
  `URLADICIONAL` varchar(300) DEFAULT NULL,
  `USERFTP` varchar(100) DEFAULT NULL,
  `PASSWORDFTP` varchar(100) DEFAULT NULL,
  `PORTAFTP` int(11) DEFAULT NULL,
  `ULTIMOSEQARQUIVO` int(11) DEFAULT NULL,
  `TIPODISPAROPERFIL` varchar(30) DEFAULT NULL,
  `NOMECAMPODISPAROVIATIMER` varchar(30) DEFAULT NULL,
  `VALORCAMPODISPAROVIATIMER` varchar(30) DEFAULT NULL,
  `TELASDISPARO` varchar(100) DEFAULT NULL,
  `SUPRIMIRLINHAVAZIA` char(1) DEFAULT NULL,
  `GERARAQUIVOSEPARADO` char(1) DEFAULT NULL,
  `CHAVEQUEBRAARQUIVO` varchar(100) DEFAULT NULL,
  `URLADICIONAL2` varchar(300) DEFAULT NULL,
  `URLADICIONAL3` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integradorexportacaocampo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integradorexportacaocampo` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_ITEM` int(11) NOT NULL DEFAULT '0',
  `NOMECAMPO` varchar(50) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SCRIPT` longtext,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_ITEM`,`NOMECAMPO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integradorexportacaojson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integradorexportacaojson` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_ITEM` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IDPAI` int(10) DEFAULT NULL,
  `DESCRICAONODO` varchar(50) NOT NULL,
  `CAMPOSUTILIZADOS` longtext NOT NULL,
  `CAMPOSAGRUPAMENTO` varchar(500) NOT NULL,
  `CAMPOCHAVE` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_ITEM`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `integradorexportacaoxml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `integradorexportacaoxml` (
  `ID_INTEGRACAO` int(11) NOT NULL DEFAULT '0',
  `ID_ITEM` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IDPAI` int(10) DEFAULT NULL,
  `DESCRICAONODO` varchar(50) NOT NULL,
  `DESCRICAOGRUPO` varchar(50) NOT NULL,
  `CAMPOSUTILIZADOS` longtext NOT NULL,
  `CAMPOSAGRUPAMENTO` varchar(500) NOT NULL,
  `CAMPOCHAVE` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_INTEGRACAO`,`ID_ITEM`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEUSUARIOAPURACAO` varchar(30) NOT NULL,
  `DATAAPURACAO` datetime NOT NULL,
  `DATAINVENTARIO` datetime NOT NULL,
  `VALORTOTALESTOQUE` double(18,8) NOT NULL,
  `TRANSMITIDOFISCO` char(1) NOT NULL,
  `MOTIVOINVENTARIO` varchar(20) NOT NULL,
  `STATUSINVENTARIO` int(11) NOT NULL COMMENT '1 = Aberto (Inventario pode ser editado), 2 = Fechado (Inventario não pode ser editado)',
  `FILTRO_TIPOVALOR` char(1) NOT NULL,
  `FILTRO_DESCARTARITENSSEMQUANTIDADE` int(11) NOT NULL,
  `FILTRO_DESCARTARITENSSEMVALORESTOQUE` int(11) NOT NULL,
  `FILTRO_DESCARTARITENSDESATIVADOS` int(11) NOT NULL,
  `FILTRO_CONSIDERARITENSUSOCONSUMO` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `inventarioitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventarioitem` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDINVENTARIO` int(11) NOT NULL DEFAULT '0',
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOITEM` varchar(20) NOT NULL,
  `DESCRICAOITEM` varchar(100) NOT NULL,
  `ORIGEMITEM` varchar(30) NOT NULL,
  `UNIDADE` varchar(20) NOT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `ALTERARMANUAL` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`),
  KEY `fk_inventarioitem_inventari` (`IDINVENTARIO`),
  CONSTRAINT `fk_inventarioitem_inventario` FOREIGN KEY (`IDINVENTARIO`) REFERENCES `inventario` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `itemmva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itemmva` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ITEM_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEMITEM` varchar(20) NOT NULL DEFAULT '',
  `UF` char(2) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCMVA` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ITEM_ID`,`ORIGEMITEM`,`UF`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `itenscompra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itenscompra` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ITC_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ITC_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `ITC_ORIGEM` varchar(30) NOT NULL DEFAULT '',
  `ITC_VALOR` double(18,8) NOT NULL,
  `ITC_CSTICMS` varchar(3) DEFAULT NULL,
  `ITC_CSTIPI` varchar(3) DEFAULT NULL,
  `ITC_CSTPIS` varchar(3) DEFAULT NULL,
  `ITC_CSTCOFINS` varchar(3) DEFAULT NULL,
  `ITC_CNAE` varchar(10) DEFAULT NULL,
  `ITC_NCM` varchar(10) DEFAULT NULL,
  `ITC_UNIDADE` varchar(10) DEFAULT NULL,
  `ITC_PERCIPI` double(18,8) DEFAULT NULL,
  `ITC_PERCICMS` double(18,8) DEFAULT NULL,
  `ITC_TIPOITEM` char(2) DEFAULT NULL,
  `ITC_TIPOMERCADORIA` char(1) DEFAULT NULL,
  `ITC_AREAUTILIZADA` int(11) DEFAULT NULL,
  `ITC_VIDAUTIL` int(11) DEFAULT NULL,
  `ITC_CODPLANOCONTA` int(11) DEFAULT NULL,
  `ITC_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `ITC_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `ITC_CODIGOANP` varchar(9) DEFAULT NULL,
  `ITC_DESCANP` varchar(150) DEFAULT NULL,
  `ITC_SALDOFISICO` double(18,8) DEFAULT NULL,
  `ITC_SALDOEMPENHADO` double(18,8) DEFAULT NULL,
  `ITC_SALDOEMPENHADOVENDA` double(18,8) DEFAULT NULL,
  `ITC_SALDOINICIAL` double(18,8) NOT NULL,
  `ITC_QTMINIMA` double(18,8) NOT NULL,
  `ITC_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `ITC_PERCGLP` double DEFAULT '0',
  `ITC_PERCGNN` double DEFAULT '0',
  `ITC_PERCGNI` double DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`ITC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`ITC_CODPLANOCONTA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `itenscompraativoimob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itenscompraativoimob` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ITC_ID` varchar(20) NOT NULL DEFAULT '',
  `ITC_NUMEROPATRIMONIO` varchar(15) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ITC_DTENTRADA` datetime DEFAULT NULL,
  `ITC_TIPOMOVIMENTACAO` varchar(2) DEFAULT '',
  `ITC_CODBEMPRINCIPAL` varchar(15) DEFAULT NULL,
  `ITC_NUMEROPARCELAS` int(11) DEFAULT NULL,
  `ITC_SERIENF` varchar(20) DEFAULT NULL,
  `ITC_NUMERONF` int(10) DEFAULT '0',
  `ITC_SEQUENCIALITEM` int(11) DEFAULT NULL,
  `ITC_CODIGOITENSCOMPRA` varchar(20) DEFAULT NULL,
  `ITC_VALORICMSAPROPRIADO` double(18,8) DEFAULT NULL,
  `ITC_VALORICMSSTAPROPRIADO` double(18,8) DEFAULT NULL,
  `ITC_DTULTIMAMOV` datetime DEFAULT NULL,
  `ITC_ULTIMAPARCELAENV` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ITC_ID`,`ITC_NUMEROPATRIMONIO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkItemCompra` (`EMP_ID`,`ITC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `laminaquant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laminaquant` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `LMQ_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CHA_ID` varchar(20) NOT NULL DEFAULT '',
  `PPO_ID` varchar(20) NOT NULL DEFAULT '',
  `MDP_ID` varchar(20) NOT NULL DEFAULT '',
  `LMQ_FORMATO` int(11) NOT NULL DEFAULT '0',
  `LMQ_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `LMQ_MEDLARGFORMATO` double(18,8) NOT NULL,
  `LMQ_MEDALTFORMATO` double(18,8) NOT NULL,
  `LMQ_TIRARETIRA` char(1) NOT NULL DEFAULT '',
  `LMQ_MAQUINAESCUSUARIO` char(1) NOT NULL DEFAULT '',
  `LMQ_PAPELESCUSUARIO` char(1) NOT NULL DEFAULT '',
  `LMQ_MEDIDALOMBADA` double(18,8) NOT NULL,
  `LMQ_TIRAGEMIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOIMPRESSAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOLAVAGEM` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRLAVAGEM` double(18,8) NOT NULL,
  `LMQ_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRACERTO` double(18,8) NOT NULL,
  `LMQ_QTMP` double(18,8) NOT NULL,
  `LMQ_VLRMP` double(18,8) NOT NULL,
  `LMQ_QTPAPEL` double(18,8) NOT NULL,
  `LMQ_VLRPAPEL` double(18,8) NOT NULL,
  `LMQ_QTPAPELPERDA` double(18,8) NOT NULL,
  `LMQ_VLRPAPELPERDA` double(18,8) NOT NULL,
  `LMQ_QTPAPELACERTO` double(18,8) NOT NULL,
  `LMQ_VLRPAPELACERTO` double(18,8) NOT NULL,
  `LMQ_QTPAGINAS` int(11) NOT NULL DEFAULT '0',
  `LMQ_QTCADERNOS` double(18,8) NOT NULL,
  `LMQ_VLRUNITARIOPAPEL` double(18,8) NOT NULL,
  `LMQ_VLRUNITARIOCHAPA` double(18,8) NOT NULL,
  `LMQ_VLRHRMAQUINA` double(18,8) NOT NULL,
  `LMQ_FORMATOMIOLOADIC` int(11) NOT NULL DEFAULT '0',
  `LMQ_MONTAGEMIOLOMADIC` int(11) NOT NULL DEFAULT '0',
  `LMQ_TIRARETIRAMIOLOADIC` char(1) NOT NULL DEFAULT '',
  `LMQ_QTPAGMIOLOADIC` int(11) NOT NULL DEFAULT '0',
  `LMQ_UNPAPEL` varchar(10) NOT NULL DEFAULT '',
  `LMQ_FORMATOMANUAL` char(1) NOT NULL DEFAULT '',
  `LMQ_ACERTOMANUAL` char(1) NOT NULL DEFAULT '',
  `LMQ_QTPEDACOPAPEL` int(11) NOT NULL DEFAULT '0',
  `LMQ_TEMPOACERTOMAQIMP` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_CALCULAEMESCALA` char(1) NOT NULL DEFAULT '',
  `LMQ_TEMPOLAVACAOMAQIMP` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_TEMPOMINIMOMAQIMP` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_QTCORESMAQIMP` int(11) NOT NULL DEFAULT '0',
  `LMQ_QTFORMACERTOMAQIMP` int(11) NOT NULL DEFAULT '0',
  `LMQ_BASEARPRODMAQIMP` int(11) NOT NULL DEFAULT '0',
  `LMQ_SETUPTINTAMAQIMP` double(18,8) DEFAULT NULL,
  `LMQ_QTMINIMATINTAMAQIMP` double(18,8) DEFAULT NULL,
  `LMQ_MIOLOESCUSUARIO` char(1) NOT NULL DEFAULT '',
  `LMQ_TEMPOACERTOCHAPAS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_QTPACOTES` int(11) NOT NULL DEFAULT '0',
  `LMQ_QTFOLHASPACOTE` double(18,8) NOT NULL,
  `LMQ_QTPAPELARRED` double(18,8) NOT NULL,
  `LMQ_VLRPAPELARRED` double(18,8) NOT NULL,
  `LMQ_ALTERARVLRPAPEL` char(1) NOT NULL DEFAULT '',
  `LMQ_PERCINDESTPAPEL` double(18,8) DEFAULT NULL,
  `LMQ_MAQREVERSAO` char(1) NOT NULL,
  `LMQ_TEMPOIMPRESSAOLP` double(18,8) NOT NULL,
  `LMQ_VALORIMPRESSAOLP` double(18,8) NOT NULL,
  `LMQ_VALORPAPELLP` double(18,8) NOT NULL,
  `LMQ_QTPAPELLP` double(18,8) NOT NULL,
  `LMQ_MEDLARGFORMATOCORTEBOBINA` double(18,8) NOT NULL,
  `LMQ_MEDALTFORMATOCORTEBOBINA` double(18,8) NOT NULL,
  `LMQ_QTCHAPASLP` double(18,8) NOT NULL,
  `LMQ_VALORCHAPALP` double(18,8) NOT NULL,
  `LMQ_MAQTIPOACERTO` varchar(20) NOT NULL,
  `LMQ_MAQTIPOLAVACAO` varchar(20) NOT NULL,
  `LMQ_CHAPACLICK` char(1) NOT NULL,
  `LMQ_FATORDIVISAOLARGURA` double(18,8) NOT NULL,
  `LMQ_FATORDIVISAOALTURA` double(18,8) NOT NULL,
  `LMQ_FATORCALCULADO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`LMQ_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkChapa` (`EMP_ID`,`CHA_ID`),
  KEY `fkPapel` (`EMP_ID`,`PPO_ID`),
  KEY `fkMedidaPapel` (`EMP_ID`,`MDP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lgpd_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lgpd_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOG_TABELA` varchar(50) NOT NULL,
  `LOG_CAMPO` varchar(100) NOT NULL,
  `LOG_VALORANTIGO` text NOT NULL,
  `LOG_VALORNOVO` text NOT NULL,
  `LOG_IDPESSOA` int(11) NOT NULL,
  `EMP_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lgpd_politicaprivacidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lgpd_politicaprivacidade` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `POLITICAPRIVACIDADE` longtext,
  `PP_VERSAO` varchar(5) NOT NULL DEFAULT '0',
  `PP_DATAVERSAO` datetime DEFAULT NULL,
  `PP_USU_ID` int(11) NOT NULL DEFAULT '0',
  `PP_USUARIOALTERACAO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LIS_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LIS_ASSUNTO` varchar(20) NOT NULL,
  `LIS_DESCRICAO` varchar(100) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LIS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listapreco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listapreco` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LTP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LTP_PRODUTO` varchar(100) NOT NULL DEFAULT '',
  `LTP_VALIDADE` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LTP_ATIVADO` char(1) NOT NULL,
  `LTP_ORIGEMLISTA` varchar(30) NOT NULL,
  `LTP_IDPAI` varchar(20) DEFAULT NULL,
  `LTP_TIPO` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LTP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listaprecocliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listaprecocliente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LTP_ID` varchar(20) NOT NULL DEFAULT '',
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LTP_ID`,`CLI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkListaPreco` (`EMP_ID`,`LTP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listaprecoitemorcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listaprecoitemorcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LTP_ID` varchar(20) NOT NULL DEFAULT '',
  `ITEM_ID` varchar(20) NOT NULL DEFAULT '',
  `LIO_ORIGEM` varchar(30) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LIO_IDFORMULAQTD` int(11) NOT NULL DEFAULT '0',
  `LIO_VALORMINIMO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LTP_ID`,`ITEM_ID`,`LIO_ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkListaPreco` (`EMP_ID`,`LTP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listaprecomaterial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listaprecomaterial` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LTP_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LTP_ID`,`MTR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkListaPreco` (`EMP_ID`,`LTP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listaprecoquantidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listaprecoquantidade` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LTP_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QTINICIAL` double(18,2) NOT NULL DEFAULT '0.00',
  `QTIFINAL` double(18,2) NOT NULL DEFAULT '0.00',
  `LTP_VALOR` double(18,8) NOT NULL,
  `MTR_ID` varchar(20) DEFAULT NULL,
  `ITEM_ID` varchar(20) DEFAULT NULL,
  `LIO_ORIGEM` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LTP_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkListaPreco` (`EMP_ID`,`LTP_ID`),
  KEY `fkListaPrecoMaterial` (`EMP_ID`,`LTP_ID`,`MTR_ID`),
  KEY `fkListaPrecoItem` (`EMP_ID`,`LTP_ID`,`ITEM_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `listausuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listausuario` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LIU_IDLISTA` int(11) NOT NULL DEFAULT '0',
  `LIU_IDUSUARIO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LIU_DESCRICAO` varchar(100) NOT NULL,
  `LIU_ALTERAR` varchar(1) DEFAULT NULL,
  `LIU_ENCAMINHAR` varchar(1) DEFAULT NULL,
  `LIU_VISUALIZAR` varchar(1) DEFAULT NULL,
  `LIU_FINALIZAR` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LIU_IDLISTA`,`LIU_IDUSUARIO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkLista` (`EMP_ID`,`LIU_IDLISTA`),
  KEY `fkUsuario` (`LIU_IDUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `localestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localestoque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOC_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOC_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LOC_PADRAO` char(1) NOT NULL DEFAULT '',
  `LOC_DESATIVADO` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `localestoquedistribuir`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localestoquedistribuir` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOCESTDISTRIBUIR` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMCADASTRO` varchar(30) NOT NULL,
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  `TIPOOPERACAO` char(1) NOT NULL,
  `ORIGEMITEM` char(1) NOT NULL,
  `CODIGOITEM` varchar(20) NOT NULL,
  `QTDITEM` double(18,8) NOT NULL,
  `SALDOITEM` double(18,8) NOT NULL,
  `CODIGOESTOQUE` int(11) NOT NULL,
  `CODIGOACERTO` varchar(30) DEFAULT NULL,
  `CODIGOREQUISICAO` int(11) DEFAULT NULL,
  `CODIGOREQUISICAOITEM` int(11) DEFAULT NULL,
  `CODIGOOP` varchar(30) DEFAULT NULL,
  `CODIGOOPPLANEJAMENTO` int(11) DEFAULT NULL,
  `REVISADO` char(1) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL,
  `PREVISAO` char(1) NOT NULL,
  `IDEXPEDICAOPEDIDO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_LOCESTDISTRIBUIR`),
  KEY `fkDocumento` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `fkRequisicao` (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGOREQUISICAOITEM`),
  KEY `fkAcerto` (`EMP_ID`,`CODIGOACERTO`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `localestoquemovimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localestoquemovimentacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOCESTMOV` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMCADASTRO` varchar(30) NOT NULL,
  `ORIGEMITEM` char(1) NOT NULL,
  `CODIGOITEM` varchar(20) NOT NULL,
  `CODIGOLOTE` varchar(40) DEFAULT NULL,
  `CODIGOLOCALEST` int(11) DEFAULT NULL,
  `DATALANCAMENTO` datetime NOT NULL,
  `TIPOOPERACAO` char(1) NOT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `CANCELADO` char(1) NOT NULL,
  `CODIGOESTOQUE` varchar(20) DEFAULT NULL,
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  `CODIGOACERTO` varchar(30) DEFAULT NULL,
  `CODIGOREQUISICAO` varchar(30) DEFAULT NULL,
  `CODIGOREQUISICAOITEM` int(11) DEFAULT NULL,
  `CODIGOOP` varchar(20) DEFAULT NULL,
  `CODIGOOPPLANEJAMENTO` int(11) DEFAULT NULL,
  `ID_LOCESTDISTRIBUIR` int(11) DEFAULT NULL,
  `PREVISAO` char(1) NOT NULL,
  `IDEXPEDICAOPEDIDO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_LOCESTMOV`),
  KEY `fkAcerto` (`EMP_ID`,`CODIGOACERTO`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOP`),
  KEY `fkDocumento` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `fkRequisicao` (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGOREQUISICAOITEM`),
  KEY `fkItem` (`EMP_ID`,`ORIGEMITEM`,`CODIGOITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `localestoquesaldo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localestoquesaldo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOCALESTSALDO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMITEM` varchar(30) NOT NULL,
  `CODIGOITEM` varchar(20) NOT NULL,
  `CODIGOLOTE` varchar(40) NOT NULL,
  `CODIGOLOCALEST` int(11) NOT NULL,
  `QTDESTOQUE` double(18,8) NOT NULL,
  `QTDESTOQUEMPENHADO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_LOCALESTSALDO`),
  KEY `fkItem` (`EMP_ID`,`ORIGEMITEM`,`CODIGOITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `localestoqueusu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localestoqueusu` (
  `EMP_ID` int(11) NOT NULL,
  `LOC_ID` int(11) NOT NULL,
  `ID_USU` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`LOC_ID`,`ID_USU`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkLocalEstoque` (`LOC_ID`),
  KEY `fkUsuario` (`ID_USU`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `loggeral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loggeral` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOG_SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOG_CHAVE` varchar(100) NOT NULL DEFAULT '',
  `USU_ID` int(11) NOT NULL DEFAULT '0',
  `LOG_TELA` varchar(50) NOT NULL DEFAULT '',
  `LOG_CADASTRO` varchar(50) NOT NULL DEFAULT '',
  `LOG_NOMETABELA` varchar(50) NOT NULL DEFAULT '',
  `LOG_DATAHORA` datetime NOT NULL,
  `LOG_TIPOACAO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`LOG_SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`USU_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `loggeralitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loggeralitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOG_SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `LOG_SEQUENCIALITEM` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOG_NOMECAMPO` varchar(50) NOT NULL DEFAULT '',
  `LOG_VALORANTIGO` text NOT NULL,
  `LOG_VALORATUAL` text NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LOG_SEQUENCIAL`,`LOG_SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkLogGeral` (`EMP_ID`,`LOG_SEQUENCIAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logmanutencaoestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logmanutencaoestoque` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `USU_ID` int(11) NOT NULL,
  `USU_NOME` varchar(30) NOT NULL,
  `LOG_DATAHORA` datetime NOT NULL,
  `LOG_JUSTIFICATIVA` varchar(200) NOT NULL,
  `LOG_DETALHAMENTO` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `logstatuscomanda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logstatuscomanda` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(11) NOT NULL,
  `CLASSIFICACAO` int(11) NOT NULL,
  `DOC_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOVOSCM` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fkDocumentoCabecalho` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lotefsc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lotefsc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDLOTE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOLOTE` varchar(40) NOT NULL DEFAULT '',
  `CODIGOENTRADA` varchar(20) DEFAULT '',
  `SEQUENCIALENTRADA` int(11) DEFAULT '0',
  `CODIGOPAPEL` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) unsigned NOT NULL,
  `TIPOOPERACAO` char(1) NOT NULL DEFAULT '',
  `NOTASERIE` varchar(20) DEFAULT NULL,
  `NUMERONOTA` int(11) unsigned DEFAULT NULL,
  `CODIGOTIPOPRODUTO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `CODIGOOP` varchar(20) DEFAULT '',
  `CODIGOESTOQUE` varchar(20) DEFAULT '',
  `DATAGRAVACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  `CODIGOTIPOLOTE` varchar(20) DEFAULT NULL,
  `ORIGEMLANCAMENTO` varchar(50) DEFAULT NULL,
  `QUANTIDADECONVERTIDAKILO` double(18,8) unsigned NOT NULL,
  PRIMARY KEY (`EMP_ID`,`IDLOTE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPapel` (`EMP_ID`,`CODIGOPAPEL`),
  KEY `fkTipoOperacao` (`EMP_ID`,`TIPOOPERACAO`),
  KEY `fkTipoProdFSC` (`EMP_ID`,`CODIGOTIPOPRODUTO`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOP`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkTipoLote` (`EMP_ID`,`CODIGOTIPOLOTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `loteproduto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loteproduto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOLOTE` varchar(40) NOT NULL DEFAULT '',
  `ORIGEMPRODUTO` char(1) NOT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SALDO` double(18,8) DEFAULT NULL,
  `SALDOEMPENHADO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOLOTE`,`ORIGEMPRODUTO`,`CODIGOPRODUTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `loteprodutomovimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loteprodutomovimentacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOTEPRODMOV` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOLOTE` varchar(40) NOT NULL DEFAULT '',
  `CODIGOOP` varchar(20) DEFAULT NULL,
  `ORIGEMPRODUTO` char(1) NOT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL,
  `DATALANCAMENTO` datetime NOT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `TIPOOPERACAO` char(1) NOT NULL,
  `NUMERONF` int(11) DEFAULT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL,
  `IDOPPRODUTO` int(11) DEFAULT NULL,
  `CODACERTO` varchar(20) DEFAULT NULL,
  `ORIGEMCADASTRO` varchar(30) NOT NULL DEFAULT '',
  `CODIGOREQUISICAO` int(11) DEFAULT NULL,
  `CODIGOREQUISICAOITEM` int(11) DEFAULT NULL,
  `CODIGOOPPLANEJAMENTO` int(11) DEFAULT NULL,
  `ID_LOCESTDISTRIBUIR` int(11) DEFAULT NULL,
  `CODIGOESTOQUE` int(11) DEFAULT NULL,
  `PREVISAO` char(1) NOT NULL,
  `IDEXPEDICAOPEDIDO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_LOTEPRODMOV`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOP`),
  KEY `fkTipoOperacao` (`EMP_ID`,`TIPOOPERACAO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akLoteProdutoMovimentacao1` (`EMP_ID`,`CODIGOLOTE`),
  KEY `akLoteProdMov1` (`EMP_ID`,`ID_LOCESTDISTRIBUIR`),
  KEY `fkAcerto` (`EMP_ID`,`CODACERTO`),
  KEY `fkDocumento` (`EMP_ID`,`DOC_ID`,`CLASSIFICACAO`),
  KEY `fkRequisicao` (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGOREQUISICAOITEM`),
  KEY `fkItem` (`EMP_ID`,`ORIGEMPRODUTO`,`CODIGOPRODUTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mailing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mailing` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAI_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ID_CONTAEMAILENVIO` int(11) NOT NULL,
  `MAI_REMETENTE` varchar(100) NOT NULL,
  `MAI_DESCRICAO` varchar(50) DEFAULT NULL,
  `MAI_ASSUNTO` varchar(50) NOT NULL,
  `MAI_CORPOEMAIL` longtext,
  `MAI_ANEXO` blob,
  PRIMARY KEY (`EMP_ID`,`MAI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mailingcontato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mailingcontato` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAC_ID` int(11) NOT NULL DEFAULT '0',
  `MAI_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `MAC_NOMEDESTINATARIO` varchar(100) DEFAULT NULL,
  `MAC_EMAILDESTINATARIO` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`MAC_ID`,`MAI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMailing` (`EMP_ID`,`MAI_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestocabecalho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestocabecalho` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(10) unsigned NOT NULL,
  `CODIGOMODELO` char(3) DEFAULT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `NUMERONF` int(11) DEFAULT NULL,
  `DATAEMISSAO` datetime NOT NULL,
  `DATAINICIOVIAGEM` datetime DEFAULT NULL,
  `DATAENTREGA` datetime DEFAULT NULL,
  `DATALANCAMENTO` datetime NOT NULL,
  `UFINICIOCARREGAMENTO` char(2) NOT NULL DEFAULT '',
  `UFFINALDESCARREGAMENTO` char(2) NOT NULL DEFAULT '',
  `IDTIPOEMITENTE` int(11) DEFAULT NULL,
  `IDTIPOTRANSPORTADOR` int(11) DEFAULT NULL,
  `IDTIPOMODALIDADE` int(11) DEFAULT NULL,
  `INDCANALVERDE` int(11) DEFAULT NULL,
  `INDCARREGAPOSTERIOR` int(11) DEFAULT NULL,
  `CANCELADA` char(1) DEFAULT NULL,
  `INFORMACOESADICIONAIS` longtext,
  `INFORMACOESCOMPLEMENTARES` longtext,
  `CODIGOUSUARIOLOGADO` int(11) DEFAULT NULL,
  `NOMEUSUARIOLOGADO` varchar(30) DEFAULT NULL,
  `MDFEENVIADASEFAZ` char(1) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `fkEmpresa` (`EMP_ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestociot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestociot` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CIOT` varchar(12) DEFAULT '',
  `CIOT_IDRESPONSAVEL` varchar(20) DEFAULT NULL,
  `CIOT_CPFCNPJRESPONSAVEL` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestociot_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestociot_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestocontratante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestocontratante` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CONTRAT_IDCONTRATANTE` varchar(20) DEFAULT NULL,
  `CONTRAT_CPFCNPJCONTRATANTE` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestocontratante_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestocontratante_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestodocumentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestodocumentos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOLOCALDESCARREGAMENTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DOC_CHAVEACESSO` varchar(44) DEFAULT NULL,
  `DOC_SEGUNDOCODBARRA` varchar(36) DEFAULT NULL,
  `DOC_INDICADORREENTREGA` int(11) DEFAULT NULL COMMENT '0 = Nao, 1 = Sim',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestodocumentos_manifestolocaldescarregamento1_idx` (`IDMANIFESTOLOCALDESCARREGAMENTO`) USING BTREE,
  CONSTRAINT `fk_manifestodocumentos_manifestolocaldescarregamento1` FOREIGN KEY (`IDMANIFESTOLOCALDESCARREGAMENTO`) REFERENCES `manifestolocaldescarregamento` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestolacres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestolacres` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MAN_NUMEROLACRE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestolacres_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestolacres_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestolocalcarregamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestolocalcarregamento` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CIDADECARREGAMENTO` varchar(50) NOT NULL DEFAULT '',
  `CODIBGECIDCARREGAMENTO` varchar(7) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestolocalcarregamento_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestolocalcarregamento_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestolocaldescarregamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestolocaldescarregamento` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CIDADEDESCARREGAMENTO` varchar(50) NOT NULL DEFAULT '',
  `CODIBGECIDDESCARREGAMENTO` varchar(7) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestolocaldescarregamento_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestolocaldescarregamento_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestoreboque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestoreboque` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `REBOQUE_IDVEICULO` int(11) DEFAULT NULL,
  `REBOQUE_IDTIPOCARROCERIA` int(11) DEFAULT NULL,
  `REBOQUE_PLACA` varchar(7) DEFAULT NULL,
  `REBOQUE_RENAVAM` varchar(11) DEFAULT NULL,
  `REBOQUE_UFLICENCIAMENTO` char(2) DEFAULT NULL,
  `REBOQUE_TARA_KG` int(11) DEFAULT NULL,
  `REBOQUE_CAPACIDADE_KG` int(11) DEFAULT NULL,
  `REBOQUE_CAPACIDADE_M3` int(11) DEFAULT NULL,
  `REBOQUE_NAOPROPRIETARIO` int(11) DEFAULT NULL COMMENT '0 = Nao, 1 = Sim',
  `REBOQUE_IDPROPRIETARIO` varchar(20) DEFAULT NULL,
  `REBOQUE_PROPRNTRC` varchar(15) DEFAULT NULL,
  `REBOQUE_PROPCPFCNPJ` varchar(15) DEFAULT NULL,
  `REBOQUE_PROPNOME` varchar(100) DEFAULT NULL,
  `REBOQUE_PROPIE` varchar(20) DEFAULT NULL,
  `REBOQUE_PROPUF` char(2) DEFAULT NULL,
  `REBOQUE_PROPIDTIPOPROPRIETARIO` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestoreboque_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  KEY `fk_manifestoreboque_veiculo1` (`REBOQUE_IDVEICULO`) USING BTREE,
  CONSTRAINT `fk_manifestoreboque_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_manifestoreboque_veiculo1` FOREIGN KEY (`REBOQUE_IDVEICULO`) REFERENCES `veiculo` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestosegurocarga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestosegurocarga` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SEGCG_IDTIPORESPONSAVEL` int(11) DEFAULT NULL,
  `SEGCG_IDRESPONSAVEL` varchar(20) DEFAULT NULL,
  `SEGCG_CPFCNPJRESPONSAVEL` varchar(15) DEFAULT NULL,
  `SEGCG_IDSEGURADORA` varchar(20) DEFAULT NULL,
  `SEGCG_CNPJSEGURADORA` varchar(15) DEFAULT NULL,
  `SEGCG_NUMAPOLICE` varchar(20) DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestosegurocarga_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestosegurocarga_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestosegurocargaaverbacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestosegurocargaaverbacao` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOSEGUROCARGA` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SEGCGAVERB_NUMEROAVERBACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestosegurocargaaverbacao_manifestosegurocarga1_idx` (`IDMANIFESTOSEGUROCARGA`) USING BTREE,
  CONSTRAINT `fk_manifestosegurocargaaverbacao_manifestosegurocarga1` FOREIGN KEY (`IDMANIFESTOSEGUROCARGA`) REFERENCES `manifestosegurocarga` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestototalizadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestototalizadores` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTOT_QTDETOTALNFE` int(11) NOT NULL,
  `MTOT_QTDETOTALCTE` int(11) NOT NULL,
  `MTOT_VALORTOTALCARGA` double(18,8) DEFAULT NULL,
  `IDTIPOPESOBRUTOCARGA` varchar(2) DEFAULT NULL,
  `MTOT_PESOBRUTOTOTALCARGA` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestototalizadores_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestototalizadores_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestoufpercurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestoufpercurso` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UFPERCURSO` char(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestoufpercurso_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestoufpercurso_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestouncarga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestouncarga` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOUNTRANSPORTE` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UNCARGA_IDTIPOUNCARGA` int(11) DEFAULT NULL,
  `UNCARGA_IDENTIFICACAOUNCARGA` varchar(20) DEFAULT NULL,
  `UNCARGA_QTDERATEADA` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestouncarga_manifestountransporte1_idx` (`IDMANIFESTOUNTRANSPORTE`) USING BTREE,
  CONSTRAINT `fk_manifestouncarga_manifestountransporte1` FOREIGN KEY (`IDMANIFESTOUNTRANSPORTE`) REFERENCES `manifestountransporte` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestouncargalacre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestouncargalacre` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOUNCARGA` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UNCARGALACRE_NUMEROLACRE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestouncargalacre_manifestouncarga1_idx` (`IDMANIFESTOUNCARGA`) USING BTREE,
  CONSTRAINT `fk_manifestouncargalacre_manifestouncarga1` FOREIGN KEY (`IDMANIFESTOUNCARGA`) REFERENCES `manifestouncarga` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestountransporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestountransporte` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTODOCUMENTOS` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UNTRANSP_IDTIPOUNTRANSPORTE` int(11) DEFAULT NULL,
  `UNTRANSP_IDENTIFICACAOUNTRANSPORTE` varchar(20) DEFAULT NULL,
  `UNTRANSP_QTDERATEADA` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestountransporte_manifestodocumentos1_idx` (`IDMANIFESTODOCUMENTOS`) USING BTREE,
  CONSTRAINT `fk_manifestountransporte_manifestodocumentos1` FOREIGN KEY (`IDMANIFESTODOCUMENTOS`) REFERENCES `manifestodocumentos` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestountransportelacre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestountransportelacre` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOUNTRANSPORTE` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `UNTRANSPLACRE_NUMEROLACRE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestountransportelacre_manifestountransporte1_idx` (`IDMANIFESTOUNTRANSPORTE`) USING BTREE,
  CONSTRAINT `fk_manifestountransportelacre_manifestountransporte1` FOREIGN KEY (`IDMANIFESTOUNTRANSPORTE`) REFERENCES `manifestountransporte` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestovalepedagio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestovalepedagio` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VPED_IDFORNECEDOR` varchar(20) DEFAULT NULL,
  `VPED_CPFCNPJFORNECEDOR` varchar(15) DEFAULT NULL,
  `VPED_NUMCOMPROVANTECOMPRA` varchar(20) DEFAULT '',
  `VPED_IDRESPONSAVAELPAGTO` varchar(20) DEFAULT NULL,
  `VPED_CPFCNPJRESPONSAVAELPAGTO` varchar(15) DEFAULT NULL,
  `VPED_VALORPEDAGIO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestovalepedagio_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_manifestovalepedagio_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestoveiculotracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestoveiculotracao` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VTRACAO_RNTRC` varchar(15) DEFAULT NULL,
  `VTRACAO_CODAGENDAMENTOPORTO` varchar(16) DEFAULT NULL,
  `VTRACAO_IDVEICULO` int(11) DEFAULT NULL,
  `VTRACAO_IDTIPOCARROCERIA` int(11) DEFAULT NULL,
  `VTRACAO_IDTIPORODADO` int(11) DEFAULT NULL,
  `VTRACAO_PLACA` varchar(7) DEFAULT NULL,
  `VTRACAO_RENAVAM` varchar(11) DEFAULT NULL,
  `VTRACAO_UFLICENCIAMENTO` char(2) DEFAULT NULL,
  `VTRACAO_TARA_KG` int(11) DEFAULT NULL,
  `VTRACAO_CAPACIDADE_KG` int(11) DEFAULT NULL,
  `VTRACAO_CAPACIDADE_M3` int(11) DEFAULT NULL,
  `VTRACAO_NAOPROPRIETARIO` int(11) DEFAULT NULL COMMENT '0 = Nao, 1 = Sim',
  `VTRACAO_IDPROPRIETARIO` varchar(20) DEFAULT NULL,
  `VTRACAO_PROPVEICRNTRC` varchar(15) DEFAULT NULL,
  `VTRACAO_PROPVEICCPFCNPJ` varchar(15) DEFAULT NULL,
  `VTRACAO_PROPVEICNOME` varchar(100) DEFAULT NULL,
  `VTRACAO_PROPVEICIE` varchar(20) DEFAULT NULL,
  `VTRACAO_PROPVEICUF` char(2) DEFAULT NULL,
  `VTRACAO_PROPVEICIDTIPOPROPRIETARIO` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestoveiculotracao_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  KEY `fk_manifestoveiculotracao_veiculo1` (`VTRACAO_IDVEICULO`) USING BTREE,
  CONSTRAINT `fk_manifestoveiculotracao_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_manifestoveiculotracao_veiculo1` FOREIGN KEY (`VTRACAO_IDVEICULO`) REFERENCES `veiculo` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `manifestoveiculotracaocondutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifestoveiculotracaocondutor` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTOVEICULOTRACAO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IDCONDUTOR` varchar(20) DEFAULT NULL,
  `CONDUTORNOME` varchar(100) DEFAULT NULL,
  `CONDUTORCPF` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_manifestoveiculotracaocondutor_manifestoveiculotracao1_idx` (`IDMANIFESTOVEICULOTRACAO`) USING BTREE,
  CONSTRAINT `fk_manifestoveiculotracaocondutor_manifestoveiculotracao1` FOREIGN KEY (`IDMANIFESTOVEICULOTRACAO`) REFERENCES `manifestoveiculotracao` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mapacusto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapacusto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAPA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(60) NOT NULL,
  `ANOMAPA` int(11) NOT NULL DEFAULT '0',
  `MESMAPA` int(11) NOT NULL DEFAULT '0',
  `FORMARATEIOADM` varchar(30) DEFAULT NULL,
  `FORMARATEIOAUX` varchar(30) DEFAULT NULL,
  `CONSIDERARDEPRECIACAO` char(1) DEFAULT NULL,
  `CONSIDERARENCARGOS` char(1) DEFAULT NULL,
  `CODIGOTIPOMAPADESP` int(11) DEFAULT NULL,
  `CODIGOTIPOMAPAEQUIP` int(11) DEFAULT NULL,
  `CODIGOTIPOMAPASALARIOS` int(11) DEFAULT NULL,
  `ANOMAPADESP` int(11) DEFAULT NULL,
  `MESMAPADESP` int(11) DEFAULT NULL,
  `ANOMAPAEQUIP` int(11) DEFAULT NULL,
  `MESMAPAEQUIP` int(11) DEFAULT NULL,
  `ANOMAPASALARIOS` int(11) DEFAULT NULL,
  `MESMAPASALARIOS` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOMAPA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mapacustovalores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapacustovalores` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAPA` int(11) NOT NULL,
  `CODIGOCENTRO` int(11) NOT NULL,
  `TIPOLCTO` char(2) NOT NULL,
  `CODCLASCONTAB` varchar(20) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VALORLCTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOMAPA`,`CODIGOCENTRO`,`TIPOLCTO`,`CODCLASCONTAB`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akEmpresa` (`EMP_ID`),
  KEY `fkMapa` (`EMP_ID`,`CODIGOMAPA`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTRO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maq` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOPROCESSO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHA_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `MAQ_TIPOPROCESSO` varchar(20) DEFAULT NULL,
  `MAQ_FORMAPAPEL` varchar(20) DEFAULT NULL,
  `MAQ_TIPOTIRAGEM` varchar(20) NOT NULL DEFAULT '',
  `MAQ_LARG_MAXAREAIMPRESSAO` double(18,8) DEFAULT NULL,
  `MAQ_ALT_MAXAREAIMPRESSAO` double(18,8) DEFAULT NULL,
  `MAQ_LARG_MINAREAIMPRESSAO` double(18,8) DEFAULT NULL,
  `MAQ_ALT_MINAREAIMPRESSAO` double(18,8) DEFAULT NULL,
  `MAQ_LARG_MAXAREAPAPEL` double(18,8) DEFAULT NULL,
  `MAQ_ALT_MAXAREAPAPEL` double(18,8) DEFAULT NULL,
  `MAQ_MINGRAMATURA` double(18,8) DEFAULT NULL,
  `MAQ_MAXGRAMATURA` double(18,8) DEFAULT NULL,
  `MAQ_QTCORES` int(11) DEFAULT NULL,
  `MAQ_MARGEMPINCA` double(18,8) DEFAULT NULL,
  `MAQ_VLRHR` double(18,8) NOT NULL,
  `MAQ_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `MAQ_TEMPOLAVAGEM` double(18,8) DEFAULT NULL,
  `MAQ_FORMACABAMENTO` varchar(20) DEFAULT NULL,
  `QTFORMATOACERTO` int(11) DEFAULT NULL,
  `MAQ_TIPOMAQUINA` varchar(20) DEFAULT NULL,
  `MAQ_PINCAINCIDE` varchar(10) DEFAULT NULL,
  `MAQ_STATUS` varchar(20) NOT NULL DEFAULT '',
  `MAQ_TEMPOUSOMINIMO` double(18,8) DEFAULT NULL,
  `MAQ_FORMULA` int(11) NOT NULL DEFAULT '0',
  `MAQ_BASEARPRODUTIVIDADE` int(11) NOT NULL DEFAULT '0',
  `MAQ_QTPEDACOS` int(11) NOT NULL DEFAULT '0',
  `MAQ_PRIMILHEIRO` double(18,8) NOT NULL,
  `MAQ_DEMMILHEIROS` double(18,8) NOT NULL,
  `MAQ_CALCULARPRODESCALA` char(1) NOT NULL DEFAULT '',
  `MAQ_LARG_MAXAREAACAB` double(18,8) DEFAULT NULL,
  `MAQ_ALT_MAXAREAACAB` double(18,8) DEFAULT NULL,
  `MAQ_LARG_MINAREAACAB` double(18,8) DEFAULT NULL,
  `MAQ_ALT_MINAREAACAB` double(18,8) DEFAULT NULL,
  `MAQ_TEMPOEXECUCAO` double(18,8) DEFAULT NULL,
  `MAQ_UTILIZARMONTIMP` char(1) NOT NULL DEFAULT '',
  `MAQ_SETUPTINTA` double(18,8) DEFAULT NULL,
  `MAQ_QTMINIMATINTA` double(18,8) DEFAULT NULL,
  `MAQ_REVERSAO` char(1) DEFAULT 'N',
  `IDENT_ID` int(11) DEFAULT NULL,
  `IDENT_IDTINT` int(11) DEFAULT NULL,
  `IDENT_IDCHAPA` int(11) DEFAULT NULL,
  `IDENT_IDPAPEL` int(11) DEFAULT NULL,
  `MAQ_APELIDO` varchar(50) DEFAULT '',
  `MAQ_NAOINCLUIRDESCAUTORC` char(1) NOT NULL,
  `MAQ_TIPOACERTO` varchar(20) NOT NULL,
  `MAQ_VERNIZEMLINHA` char(1) NOT NULL,
  `MAQ_CODIGOTINTAVERNIZ` varchar(30) DEFAULT NULL,
  `MAQ_VERNIZPECFRENTE` double(18,8) DEFAULT NULL,
  `MAQ_VERNIZPECVERSO` double(18,8) DEFAULT NULL,
  `MAQ_TIPOLAVACAO` varchar(20) NOT NULL,
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `MAQ_OBSOPOBRIGATORIA` char(1) DEFAULT NULL,
  `MAQ_OBSORCOBRIGATORIA` char(1) DEFAULT NULL,
  `ID_SCRIPT` int(11) DEFAULT NULL,
  `MAQ_PLOTTER` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkChapa` (`EMP_ID`,`CHA_ID`),
  KEY `fkIndentCusto` (`EMP_ID`,`IDENT_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinacoresreversao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinacoresreversao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_IDCOR` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CORFRENTEVERSAO` int(11) NOT NULL DEFAULT '0',
  `CORVERSOREVERSAO` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`MAQ_IDCOR`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinaexecformimp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinaexecformimp` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FORMATO` int(11) NOT NULL DEFAULT '0',
  `EXECUCOES` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinaexecmontagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinaexecmontagem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `EXECUCOES` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinafatoracertoprodutividade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinafatoracertoprodutividade` (
  `EMP_ID` int(11) NOT NULL,
  `MAQ_ID` varchar(20) NOT NULL,
  `FTI_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QTINICIAL` int(11) NOT NULL,
  `PRODUTIVIDADE` double(18,8) NOT NULL,
  `ACERTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`FTI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinafolhasgramatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinafolhasgramatura` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GRAMATURA` double(18,8) NOT NULL,
  `QTFOLHAS` int(11) NOT NULL DEFAULT '0',
  `GRAMATURAFINAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinamatprima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinamatprima` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOACABAMENTO` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTCONSUMO` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `UNIDADECONSUMO` varchar(10) NOT NULL DEFAULT '',
  `QTMINIMACONSUMO` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `CALCULAUSANDOFORMULA` char(1) NOT NULL DEFAULT '',
  `CODIGOFORMULA` int(11) NOT NULL DEFAULT '0',
  `MTR_ID` varchar(20) DEFAULT '',
  `FOR_IDQUANT` int(11) DEFAULT '0',
  `FOR_IDVALOR` int(11) DEFAULT '0',
  `QTCONSUMO2` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOACABAMENTO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`CODIGOACABAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinaquebra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinaquebra` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `MQE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MQE_QTINICIAL` int(11) NOT NULL DEFAULT '0',
  `MQE_QTFINAL` int(11) NOT NULL DEFAULT '0',
  `MQE_QUEBRA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`MQE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinatinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinatinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PECFRENTE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `PECVERSO` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`TIN_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkTinta` (`EMP_ID`,`TIN_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `maquinatiragem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinatiragem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `MTI_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTI_QTINICIAL` int(11) NOT NULL DEFAULT '0',
  `MTI_QTFINAL` int(11) NOT NULL DEFAULT '0',
  `MTI_TIRAGEM` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`MAQ_ID`,`MTI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_CLASSIFICACAO` varchar(20) NOT NULL DEFAULT '',
  `MTR_TIPO` varchar(20) NOT NULL DEFAULT '',
  `MTR_DESCRICAO` varchar(500) NOT NULL DEFAULT '',
  `MTR_ESPECIFICACAO` longtext,
  `UN_CONSUMO` varchar(10) NOT NULL DEFAULT '',
  `MTR_CODREF` varchar(35) NOT NULL DEFAULT '',
  `MTR_QTMINIMA` double(18,8) DEFAULT NULL,
  `MTR_PRECOCUSTO` double(18,8) NOT NULL,
  `MTR_PRECOVENDA` double(18,8) NOT NULL,
  `MTR_IDPAI` varchar(20) DEFAULT NULL,
  `MTR_DTULTIMALTERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `MTR_CST` varchar(5) DEFAULT NULL,
  `MTR_CLASSFISCAL` varchar(10) DEFAULT NULL,
  `MTR_PERCIPI` double(18,8) DEFAULT NULL,
  `MTR_PERCISS` double(18,8) DEFAULT NULL,
  `MTR_FLAGPRODUTO` char(1) NOT NULL DEFAULT '',
  `MTR_FLAGMATERIAPRIMA` char(1) NOT NULL DEFAULT '',
  `MTR_FLAGSERVICO` char(1) NOT NULL DEFAULT '',
  `MTR_PESOUNITARIO` double(18,8) NOT NULL,
  `MTR_PESOUNITARIOLIQUIDO` double(18,8) NOT NULL,
  `MTR_CODIGOEMBALAGEM` varchar(20) DEFAULT NULL,
  `MTR_QTDADEEMBALAGEM` double(18,8) DEFAULT NULL,
  `MTR_UNIDADEEMBALAGEM` varchar(10) DEFAULT NULL,
  `UN_COMPRA` varchar(10) DEFAULT NULL,
  `UN_ARMAZENAGEM` varchar(10) DEFAULT NULL,
  `MTR_CURSOX` double(18,8) NOT NULL,
  `MTR_SALDOINICIAL` double(18,8) DEFAULT NULL,
  `MTR_PERCICMS` double(18,8) DEFAULT NULL,
  `MTR_SALDOFISICO` double(18,8) DEFAULT NULL,
  `MTR_SALDOEMPENHADO` double(18,8) DEFAULT NULL,
  `MTR_TIPOCOMPOSICAO` varchar(15) DEFAULT NULL,
  `CODIGOPUBLICACAO` int(11) DEFAULT NULL,
  `MTR_CSTIPI` varchar(20) DEFAULT NULL,
  `MTR_CSTPIS` varchar(20) DEFAULT NULL,
  `MTR_CSTCOFINS` varchar(20) DEFAULT NULL,
  `MTR_PRECOMEDIO` double(18,5) DEFAULT '0.00000',
  `MTR_CNAE` varchar(10) DEFAULT NULL,
  `MTR_CODIGOATIVIDADE` varchar(15) DEFAULT NULL,
  `CODIGOTRIBUTACAONFSE` varchar(20) DEFAULT NULL,
  `MTR_PERCCOMISSAO` double(18,8) DEFAULT NULL,
  `MTR_DESATIVADO` char(1) DEFAULT 'N',
  `MTR_PERCICMSST` double(18,8) DEFAULT NULL,
  `PROD_EAN` varchar(14) DEFAULT NULL,
  `PROD_EANTRIB` varchar(14) DEFAULT NULL,
  `MTR_TIPOITEM` char(2) DEFAULT NULL,
  `MTR_SALDOEMPENHADOVENDA` double(18,8) DEFAULT NULL,
  `MTR_CODIGOBARRACAIXA` varchar(13) DEFAULT NULL,
  `MTR_CODIGOBARRAPACOTE` varchar(13) DEFAULT NULL,
  `MTR_CODIGOBARRAUNIDADE` varchar(13) DEFAULT NULL,
  `MTR_FORMATOCAIXA` varchar(30) DEFAULT NULL,
  `MTR_UNIDADESPACOTE` double(18,8) DEFAULT NULL,
  `MTR_UNIDADESEMBALAGEM` double(18,8) DEFAULT NULL,
  `MTR_MARCA` varchar(50) DEFAULT NULL,
  `MTR_DTLIBERACAOVENDA` datetime DEFAULT NULL,
  `MTR_PERCPIS` double(18,8) DEFAULT NULL,
  `MTR_PERCCOFINS` double(18,8) DEFAULT NULL,
  `IDENT_ID` int(11) DEFAULT NULL,
  `MTR_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `MTR_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `MTR_SALDOEMPENHADOPRODUCAO` double(18,8) DEFAULT NULL,
  `MTR_VALORCOMPRA` double(18,8) DEFAULT NULL,
  `MTR_DATAALTERACAOVLRCOMPRA` datetime DEFAULT NULL,
  `MTR_ENQUADRAMENTOTRIB` varchar(30) DEFAULT NULL,
  `MTR_VALORSEMICMSIPI` double(18,8) DEFAULT NULL,
  `MTR_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `MTR_COMODATO` char(1) DEFAULT NULL,
  `MTR_ISBN` char(1) DEFAULT NULL,
  `CODIGOOPORIGEM` varchar(30) DEFAULT NULL,
  `INFORMARVALORMEDIOMANUAL` char(1) DEFAULT 'N',
  `MTR_CODPLANOCONTA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`MTR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoEmb` (`EMP_ID`,`MTR_CODIGOEMBALAGEM`),
  KEY `fkPublicacao` (`EMP_ID`,`CODIGOPUBLICACAO`),
  KEY `fkIdentCusto` (`EMP_ID`,`IDENT_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akGrupo` (`EMP_ID`,`MTR_IDPAI`,`MTR_CLASSIFICACAO`),
  KEY `akOPOrigem` (`EMP_ID`,`CODIGOOPORIGEM`),
  KEY `fkPlanoConta` (`EMP_ID`,`MTR_CODPLANOCONTA`),
  KEY `akDescMaterial` (`MTR_DESCRICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `materialcomposicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materialcomposicao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_IDCOMPOSICAO` varchar(20) NOT NULL DEFAULT '',
  `MTR_CLASSIFICACAO` varchar(20) NOT NULL DEFAULT '',
  `MTR_QUANTIDADE` double(18,8) NOT NULL,
  `MTR_UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `MTR_PRECOCUSTO` double(18,8) NOT NULL,
  `MTR_PRECOTOTAL` double(18,8) NOT NULL,
  `ORIGEMMATERIAL` char(1) NOT NULL DEFAULT '',
  `PESOUNITARIO` double(18,8) NOT NULL,
  `PESOTOTAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MTR_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkMaterialcomp` (`EMP_ID`,`MTR_IDCOMPOSICAO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `materialdispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materialdispositivolegal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGODISPOSITIVOLEGAL` varchar(30) NOT NULL DEFAULT '',
  `CODIGOMATERIAL` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGODISPOSITIVOLEGAL`,`CODIGOMATERIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaterial` (`EMP_ID`,`CODIGOMATERIAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mdfe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdfe` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERONOTA` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `CHAVEACESSO` varchar(44) DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) NOT NULL DEFAULT '',
  `IPORIGEM` varchar(20) NOT NULL DEFAULT '',
  `TIPOOPERACAO` varchar(50) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` longtext,
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  `RECIBO` varchar(15) NOT NULL DEFAULT '',
  `PRIORIDADE` varchar(50) NOT NULL DEFAULT '',
  `DATAHORAENVIO` datetime DEFAULT NULL,
  `DATAHORARETORNO` datetime DEFAULT NULL,
  `TOTALNOTA` double(18,8) NOT NULL,
  `VERSAOMDFE` varchar(5) DEFAULT NULL,
  `QRCODE` longtext,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_mdfe_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_mdfe_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mdfeeventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdfeeventos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOEVENTO` varchar(20) DEFAULT NULL,
  `IDEVENTO` int(11) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `PROTOCOLO` varchar(15) NOT NULL DEFAULT '',
  `FORMAEMISSAO` varchar(50) NOT NULL DEFAULT '',
  `IPORIGEM` varchar(20) NOT NULL DEFAULT '',
  `TIPOOPERACAO` varchar(50) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAHORAENVIO` datetime DEFAULT NULL,
  `DATAHORARETORNO` datetime DEFAULT NULL,
  `IDCONDUTOR` varchar(20) DEFAULT NULL,
  `CONDUTORNOME` varchar(100) DEFAULT NULL,
  `CONDUTORCPF` varchar(15) DEFAULT NULL,
  `UFENCERRAMENTO` char(2) DEFAULT NULL,
  `CIDADEDESCARREGAMENTO` varchar(50) DEFAULT NULL,
  `CODIBGECIDDESCARREGAMENTO` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_mdfeeventos_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_mdfeeventos_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mdfeocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdfeocorrencias` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERONOTA` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `DATAHORA` datetime DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_mdfeocorrencias_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_mdfeocorrencias_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mdfeprotocolos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdfeprotocolos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDMANIFESTO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERONOTA` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `PROTOCOLO` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `akTrigger1` (`DATA_ALTERACAO`) USING BTREE,
  KEY `fk_mdfeprotocolos_manifestocabecalho1_idx` (`IDMANIFESTO`) USING BTREE,
  CONSTRAINT `fk_mdfeprotocolos_manifestocabecalho1` FOREIGN KEY (`IDMANIFESTO`) REFERENCES `manifestocabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `medpapel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medpapel` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MDP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MDP_CODIGO_DIF` varchar(20) DEFAULT NULL,
  `MDP_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `MDP_MEDLARGURA` double(18,8) NOT NULL,
  `MDP_MEDALTURA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MDP_ID`),
  UNIQUE KEY `MDP_CODIGO_DIF` (`MDP_CODIGO_DIF`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `meiospagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meiospagamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCONTABANCARIA` varchar(20) DEFAULT '',
  `DIASLIQUIDACAO` int(11) DEFAULT '0',
  `PERCDESCONTO` float DEFAULT '0',
  `DESCRICAOABREVIADA` varchar(5) DEFAULT '',
  `IDINSTITUICAOPAGTO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkContaBancaria` (`EMP_ID`,`CODIGOCONTABANCARIA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fk_meiospagamento_bandeiracartao` (`IDINSTITUICAOPAGTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `midia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `midia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MID_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MID_DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`MID_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moedas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moedas` (
  `SIGLAMOEDA` char(3) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEMOEDA` varchar(20) NOT NULL,
  PRIMARY KEY (`SIGLAMOEDA`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `moedascotacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moedascotacao` (
  `ID_COTACAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SIGLAMOEDA` char(3) NOT NULL,
  `VALORCOTACAO` double(18,8) NOT NULL,
  `DATACOTACAO` datetime NOT NULL,
  PRIMARY KEY (`ID_COTACAO`),
  KEY `akTrigger1` (`DATA_ALTERACAO`),
  KEY `akMoedas` (`SIGLAMOEDA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `naoconformidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naoconformidades` (
  `EMP_ID` int(11) NOT NULL,
  `CODIGO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `naoconformidadesocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naoconformidadesocorrencias` (
  `EMP_ID` int(11) NOT NULL,
  `CODIGO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(50) DEFAULT NULL,
  `DATA_RECLAMACAO` datetime DEFAULT NULL,
  `CODIGOPESSOA` int(11) DEFAULT NULL,
  `NOMEPESSOA` varchar(50) DEFAULT NULL,
  `EMITENTE` varchar(50) DEFAULT NULL,
  `DATA_CONCLUSAO` datetime DEFAULT NULL,
  `USUARIO_CONCLUSAO` varchar(50) DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT NULL,
  `FLAGRETRABALHO` varchar(1) DEFAULT NULL,
  `FLAGNAOCONFORMERETORNOU` varchar(1) DEFAULT NULL,
  `ORIGEM` varchar(20) DEFAULT NULL,
  `PRAZO_SOLUCAO` datetime DEFAULT NULL,
  `DATA_SOLUCAO` datetime DEFAULT NULL,
  `SETOR_SOLUCAO` int(11) DEFAULT NULL,
  `SOLUCAOIMEDIATA` text,
  `SOLUCAOSETORORIGEM` text,
  `DATA_FEEDBACK` datetime DEFAULT NULL,
  `FEEDBACKCLIENTE` text,
  `DATA_ANALISE` datetime DEFAULT NULL,
  `ANALISE` text,
  `STATUSQUALIDADE` varchar(20) DEFAULT NULL,
  `FLAGACAOCORRETIVA` varchar(1) DEFAULT NULL,
  `NAOCONFORMIDADE` int(11) DEFAULT NULL,
  `NAOCONFORMIDADEREAL` int(11) DEFAULT NULL,
  `ORIGEMRETRABALHO` varchar(20) DEFAULT NULL,
  `PRODUTOSERVICO` varchar(11) DEFAULT NULL,
  `DESCRICAOPRODUTOSERVICO` varchar(50) DEFAULT NULL,
  `PRODUTOSERVICORETRABALHO` varchar(11) DEFAULT NULL,
  `DESCRICAOPRODUTOSERVICORETRABALHO` varchar(50) DEFAULT NULL,
  `HISTORICO` text,
  `CONTATO` int(11) DEFAULT NULL,
  `CAUSARAIZ` text,
  `DATA_REGISTROCAUSA` datetime DEFAULT NULL,
  `VALORCAUSARAIZ` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`),
  KEY `fkNaoConformidade` (`EMP_ID`,`NAOCONFORMIDADE`),
  KEY `fkNaoConformidadeReal` (`EMP_ID`,`NAOCONFORMIDADEREAL`),
  KEY `fkProdutoServico` (`EMP_ID`,`PRODUTOSERVICO`),
  KEY `fkProdutoServicoRetrabalho` (`EMP_ID`,`PRODUTOSERVICORETRABALHO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `naoconformidadesocorrenciasarquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naoconformidadesocorrenciasarquivos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `NCO_ID` varchar(20) NOT NULL DEFAULT '',
  `ID_ARQUIVO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LOCALIZACAOARQUIVO` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`NCO_ID`,`ID_ARQUIVO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNaoConformidadesocorrencias` (`EMP_ID`,`NCO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `naturezaoperacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naturezaoperacao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `NAT_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CFO_CODIGO` varchar(5) NOT NULL DEFAULT '00000',
  `DESCRICAO` varchar(200) NOT NULL DEFAULT '',
  `GERARCOMISSAO` char(1) NOT NULL DEFAULT '',
  `GERARFATURAMENTO` char(1) NOT NULL DEFAULT '',
  `GERARFATNOTASAJUSTE` char(1) NOT NULL DEFAULT '',
  `GERARFATNOTASCOMPLEMENTARES` char(1) NOT NULL DEFAULT '',
  `GERARESTOQUE` char(1) NOT NULL DEFAULT '',
  `GERARESTNOTASAJUSTE` char(1) NOT NULL DEFAULT '',
  `GERARESTNOTASCOMPLEMENTARES` char(1) NOT NULL DEFAULT '',
  `DESTACARICMSFRETE` char(1) NOT NULL DEFAULT '',
  `DESTACARICMSSEGURO` char(1) NOT NULL DEFAULT '',
  `DESTACARICMSOUTROS` char(1) NOT NULL DEFAULT '',
  `PERMITIRICMSPARCIAL` char(1) NOT NULL DEFAULT '',
  `PERCICMSPARCIAL` double(18,8) DEFAULT NULL,
  `CST_ICMS` varchar(3) DEFAULT NULL,
  `CST_IPI` varchar(3) DEFAULT NULL,
  `CST_PIS` varchar(3) DEFAULT NULL,
  `CST_COFINS` varchar(3) DEFAULT NULL,
  `CST_SERVICO` varchar(3) DEFAULT NULL,
  `USARIPICOMPORBCIMCS` varchar(1) NOT NULL,
  `CALCULARMANUALMENTE` varchar(1) NOT NULL,
  `USARCSTCFOP` char(1) DEFAULT NULL,
  `SIMPLESREMESSA` char(1) NOT NULL,
  `DESTACARIPIFRETE` char(1) NOT NULL DEFAULT '',
  `DESTACARIPISEGURO` char(1) NOT NULL DEFAULT '',
  `DESTACARIPIOUTROS` char(1) NOT NULL DEFAULT '',
  `CFOINVERSA_CODIGO` varchar(5) DEFAULT NULL,
  `USARPRECOCUSTO` char(1) DEFAULT 'N',
  `NATOP_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `DESTACARPISCOFINSFRETE` char(1) NOT NULL DEFAULT '',
  `DESTACARPISCOFINSSEGURO` char(1) NOT NULL DEFAULT '',
  `DESTACARPISCOFINSOUTROS` char(1) NOT NULL DEFAULT '',
  `NATOP_INDICADORESTOQUE` int(11) DEFAULT NULL,
  `CONSIDERARTAXAIMPORTACAO` char(1) NOT NULL,
  `CONSIDERARPISCOFINS` char(1) NOT NULL,
  `CONSIDERARICMS` char(1) NOT NULL,
  `CODBENEFICIOFISCAL` varchar(20) DEFAULT NULL,
  `CODBENEFICIOFISCALPRESUMIDO` varchar(20) DEFAULT NULL,
  `CODBENEFICIOFISCALPRESUMIDORBC` varchar(20) DEFAULT NULL,
  `MOTIVODESONERACAOICMS` varchar(30) DEFAULT NULL,
  `TIPOCALCULODIFERIMENTO` int(11) DEFAULT '1',
  `TIPOCALCULOPRESUMIDO` int(11) DEFAULT '1',
  `DEDUZIRDESONERACAOVLRNF` int(11) DEFAULT '0',
  `TIPOCALCULODESONERACAO` int(11) DEFAULT '1',
  `PERCICMSDIF` double(18,8) DEFAULT NULL,
  `PERCICMSDESONERADO` double(18,8) DEFAULT NULL,
  `PERCBENEFICIOFISCALPRESUMIDO` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`NAT_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `naturezaoperacaodispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naturezaoperacaodispositivolegal` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `NAT_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGODISPOSITIVOLEGAL` varchar(30) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`NAT_ID`,`CODIGODISPOSITIVOLEGAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNatOP` (`EMP_ID`,`NAT_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nbs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nbs` (
  `NBS_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NBS_NIVELCOD` int(10) unsigned NOT NULL DEFAULT '0',
  `NBS_PAICOD` varchar(15) DEFAULT NULL,
  `NBS_CODIGO` varchar(15) NOT NULL DEFAULT '0',
  `NBS_DESC` varchar(200) NOT NULL DEFAULT '0',
  `NBS_VISIVEL` varchar(1) NOT NULL DEFAULT 'S',
  `NBS_TIPOLANCAMENTO` varchar(30) NOT NULL,
  `DESATIVADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`NBS_ID`),
  KEY `akNBS1` (`NBS_CODIGO`),
  KEY `akNBS2` (`NBS_PAICOD`),
  KEY `akNBS3` (`NBS_NIVELCOD`),
  KEY `akNBS4` (`NBS_DESC`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=1204 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ncm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ncm` (
  `NCM_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NCM_NIVELCOD` int(10) unsigned NOT NULL DEFAULT '0',
  `NCM_PAICOD` varchar(10) DEFAULT NULL,
  `NCM_CODIGO` varchar(10) NOT NULL DEFAULT '0',
  `NCM_DESC` varchar(200) NOT NULL DEFAULT '0',
  `NCM_VISIVEL` varchar(1) NOT NULL DEFAULT 'S',
  `NCM_TIPOLANCAMENTO` varchar(30) NOT NULL,
  `DESATIVADA` char(1) DEFAULT NULL,
  `DESONERADO` char(1) DEFAULT 'N',
  `ALIQUOTA` double(18,8) DEFAULT '0.00000000',
  `DATAULTATUALIZACAO` datetime DEFAULT NULL,
  PRIMARY KEY (`NCM_ID`),
  KEY `akNCM1` (`NCM_CODIGO`),
  KEY `akNCM2` (`NCM_PAICOD`),
  KEY `akNCM3` (`NCM_NIVELCOD`),
  KEY `akNCM4` (`NCM_DESC`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB AUTO_INCREMENT=16685 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfce` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `CHAVEACESSO` varchar(44) DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) NOT NULL DEFAULT '',
  `IPORIGEM` varchar(20) NOT NULL DEFAULT '',
  `TIPOOPERACAO` varchar(50) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` longtext,
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  `RECIBO` varchar(15) NOT NULL DEFAULT '',
  `PRIORIDADE` varchar(50) NOT NULL DEFAULT '',
  `ENVIADOEMAIL` char(1) NOT NULL DEFAULT '',
  `DATAHORAENVIO` datetime DEFAULT NULL,
  `DATAHORARETORNO` datetime DEFAULT NULL,
  `NOMECLIENTE` varchar(100) NOT NULL DEFAULT '',
  `TOTALNOTA` double(18,8) NOT NULL,
  `EMAILCLIENTE` varchar(100) DEFAULT NULL,
  `ENVIADOEMAILCANCEL` char(1) NOT NULL DEFAULT 'S',
  `DATAHORAENVIOEMAILNFCE` datetime DEFAULT NULL,
  `OCORRENCIAENVIOEMAIL` longtext,
  `VERSAONFCE` varchar(5) DEFAULT NULL,
  `QRCODE` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDocumentoCabecalho` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfceinutilizadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfceinutilizadas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `NUMEROINICIAL` int(11) NOT NULL DEFAULT '0',
  `NUMEROFINAL` int(11) NOT NULL DEFAULT '0',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `DATA` datetime DEFAULT NULL,
  `JUSTIFICATIVA` longtext NOT NULL,
  `SEQUENCIALULTIMAOCORRENCIA` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfceocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfceocorrencias` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `DATAHORA` datetime DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `akNFCeOcorrencias` (`STATUS`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFCe` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfceprotocolos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfceprotocolos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `PROTOCOLO` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFCe` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfe` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `STATUS` varchar(50) NOT NULL DEFAULT '' COMMENT 'TTS_PENDENTEENVIO\r\nTTS_PENDENTERESPOSTA\r\nTTS_AUTORIZADA\r\nTTS_DANFENAOGERADO\r\nTTS_DANFEGERADO\r\nTTS_DENEGACAO\r\nTTS_REJEICAO\r\nTTS_PENDENTECANCELAMENTO\r\nTTS_CANCELADA\r\nTTS_HOMOLOGACAO\r\nTTS_DANFEIMPRESSO\r\nTTS_REGERARDANFE\r\nTTS_DIRECIONADOCONT\r\nTTS_INUTILIZADA\r\nTTS_INUTILIZADAREJEITADA\r\nTTS_MDFEENCERRADO',
  `CHAVEACESSO` varchar(44) DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) NOT NULL DEFAULT '',
  `IPORIGEM` varchar(20) NOT NULL DEFAULT '',
  `TIPOOPERACAO` varchar(50) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` longtext,
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  `RECIBO` varchar(15) NOT NULL DEFAULT '',
  `PRIORIDADE` varchar(50) NOT NULL DEFAULT '',
  `ENVIADOEMAIL` char(1) NOT NULL DEFAULT '',
  `DATAHORAENVIO` datetime DEFAULT NULL,
  `DATAHORARETORNO` datetime DEFAULT NULL,
  `NOMECLIENTE` varchar(100) NOT NULL DEFAULT '',
  `TOTALNOTA` double(18,8) NOT NULL,
  `EMAILCLIENTE` varchar(100) DEFAULT NULL,
  `ENVIADOEMAILCANCEL` char(1) NOT NULL DEFAULT 'S',
  `DATAHORAENVIOEMAILNFE` datetime DEFAULT NULL,
  `OCORRENCIAENVIOEMAIL` longtext,
  `VERSAONFE` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDocumentoCabecalho` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfecorrecao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfecorrecao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALEVENTO` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `NFE_NUMERO` int(10) unsigned NOT NULL,
  `NFE_NUMEROSERIE` varchar(20) NOT NULL,
  `NFE_CHAVEACESSO` varchar(44) NOT NULL,
  `NFE_DATACORRECAO` datetime NOT NULL,
  `LOTE_ID` int(10) unsigned NOT NULL,
  `TIPOEVENTO` varchar(20) DEFAULT NULL,
  `VERSAOEVENTO` varchar(15) DEFAULT NULL,
  `DESCRICAOEVENTO` varchar(30) DEFAULT NULL,
  `DESCRICAOCORRECAO` longtext,
  `IPORIGEM` varchar(20) DEFAULT NULL,
  `NOMEUSUARIO` varchar(30) DEFAULT NULL,
  `PROTOCOLO` varchar(50) DEFAULT NULL,
  `ENVIADOEMAIL` char(1) NOT NULL,
  `IMPRESSA` varchar(1) DEFAULT NULL,
  `EMAILCLIENTE` varchar(100) DEFAULT NULL,
  `VERSAONFE` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALEVENTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFe` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfeinutilizadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfeinutilizadas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `NUMEROINICIAL` int(11) NOT NULL DEFAULT '0',
  `NUMEROFINAL` int(11) NOT NULL DEFAULT '0',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `DATA` datetime DEFAULT NULL,
  `JUSTIFICATIVA` longtext NOT NULL,
  `SEQUENCIALULTIMAOCORRENCIA` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfemanifestacaodest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfemanifestacaodest` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_MANIFESTACAO` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHAVENFE` varchar(44) NOT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `CNPJ` varchar(14) NOT NULL,
  `NOME` varchar(100) NOT NULL,
  `INSCRESTADUAL` varchar(20) DEFAULT NULL,
  `DATAEMISSAO` datetime NOT NULL,
  `TIPOOPERACAO` varchar(20) NOT NULL DEFAULT '',
  `TOTALNOTA` double(18,8) NOT NULL,
  `STATUSNOTA` varchar(50) NOT NULL DEFAULT '',
  `NSUCONSULTA` varchar(20) NOT NULL DEFAULT '',
  `MANIFESTACAO` varchar(20) DEFAULT NULL,
  `JUSTIFICATIVACONF` longtext,
  `IPORIGEM` varchar(20) DEFAULT NULL,
  `NOMEUSUARIO` varchar(30) DEFAULT NULL,
  `PROTOCOLO` varchar(50) DEFAULT NULL,
  `DATAHORARETORNO` datetime DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL,
  `CODIGOOCORRENCIA` int(11) DEFAULT NULL,
  `DESCRICAOOCORRENCIA` longtext,
  `NOTAIMPORTADA` char(1) NOT NULL,
  `XMLDISPONIVEL` char(1) NOT NULL,
  PRIMARY KEY (`ID_MANIFESTACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNfeManifestacaoDestNSU` (`EMP_ID`,`NSUCONSULTA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfemanifestacaodestnsu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfemanifestacaodestnsu` (
  `EMP_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ULTIMONSU` varchar(20) NOT NULL,
  `DATAULTIMACONSULTA` datetime NOT NULL,
  `MOTIVO` varchar(100) NOT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfeocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfeocorrencias` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `DATAHORA` datetime DEFAULT NULL,
  `FORMAEMISSAO` varchar(50) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOOCORRENCIA` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `akNFeOcorrencias1` (`STATUS`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFe` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfeprotocolos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfeprotocolos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIE` varchar(20) NOT NULL DEFAULT '',
  `PROTOCOLO` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFe` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfse` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SERIENF` varchar(20) NOT NULL,
  `SERIERPS` varchar(20) NOT NULL,
  `SERIENFSE` varchar(20) DEFAULT NULL,
  `NUMERONF` int(10) unsigned NOT NULL,
  `NUMERORPS` int(10) unsigned NOT NULL,
  `NUMERONFSE` bigint(15) unsigned DEFAULT NULL,
  `NUMERORPSENVIO` int(10) unsigned DEFAULT NULL,
  `STATUS` varchar(22) NOT NULL COMMENT 'TNFSE_PENDENTEENVIO\r\nTNFSE_PENDENTERESPOSTA\r\nTNFSE_RETORNOERRO\r\nTNFSE_ATIVO\r\nTNFSE_PENDENTECANCEL\r\nTNFSE_CANCELADO\r\nTNFSE_ENVIADOWEBSEVICE\r\nTNFSE_GERARRPS\r\nTNFSE_RPSGERADO\r\nTNFSE_RPSIMPRESSO\r\nTNFSE_ERROGERARRPS',
  `PROTOCOLO` varchar(50) DEFAULT NULL,
  `CODVERIFICACAO` varchar(50) DEFAULT NULL,
  `LOTE_ID` int(10) unsigned DEFAULT NULL,
  `AMBIENTE` varchar(15) DEFAULT NULL,
  `OPCOESESPECIFICAS` varchar(32) DEFAULT NULL,
  `DATAHORAEMISSAORPS` datetime DEFAULT NULL,
  `DATAHORAEMISSAONFSE` datetime DEFAULT NULL,
  `DATAHORACANCELAMENTO` datetime DEFAULT NULL,
  `MOTIVOCANCELAMENTOID` int(10) unsigned DEFAULT NULL,
  `MOTIVOCANCELAMENTODESC` varchar(128) DEFAULT NULL,
  `IPORIGEM` varchar(20) NOT NULL,
  `NOMEUSUARIO` varchar(30) NOT NULL,
  `URLIMPRESSAO` varchar(500) DEFAULT NULL,
  `PERMITIPROCESSAR` char(1) DEFAULT '',
  `CHAVEACESSO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDocumentoCabecalho` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`),
  KEY `fkDocumentoItem` (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfselotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfselotes` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `LOTE_ID` int(10) unsigned NOT NULL,
  `SERIERPS` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LOTE_ID_ENVIADO` int(10) unsigned DEFAULT NULL,
  `PROTOCOLO` varchar(50) DEFAULT NULL,
  `AMBIENTE` varchar(15) DEFAULT NULL,
  `STATUS` varchar(22) NOT NULL,
  `DATAGERACAOLOTE` datetime NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LOTE_ID`,`SERIERPS`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFSe` (`EMP_ID`,`LOTE_ID`,`SERIERPS`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nfseocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfseocorrencias` (
  `OCO_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(10) unsigned NOT NULL,
  `LOTE_ID` int(10) unsigned NOT NULL,
  `LOTE_ID_ENVIADO` int(10) unsigned DEFAULT NULL,
  `RPS_SERIE` varchar(20) DEFAULT NULL,
  `RPS_NUMERO` int(10) unsigned DEFAULT NULL,
  `PROTOCOLO` varchar(50) DEFAULT NULL,
  `DATAHORA` datetime NOT NULL,
  `STATUS` varchar(22) NOT NULL,
  `OCO_CODIGO` varchar(8) NOT NULL,
  `OCO_DESCRICAO` varchar(1024) DEFAULT NULL,
  `OCO_SOLUCAO` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`OCO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNFSe` (`EMP_ID`,`LOTE_ID`,`RPS_SERIE`),
  KEY `fkLote` (`EMP_ID`,`LOTE_ID`,`RPS_SERIE`,`LOTE_ID_ENVIADO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nsu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nsu` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAHORA` datetime DEFAULT NULL,
  `NUMERONSU` int(11) NOT NULL DEFAULT '0',
  `NUMERONF` int(11) DEFAULT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `VALORNF` double(18,8) NOT NULL,
  `MOTIVO` varchar(100) DEFAULT NULL,
  `TIPONSU` varchar(11) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ocorrencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ocorrencia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `COR` int(10) DEFAULT NULL,
  `TECLAATALHO` char(1) DEFAULT NULL,
  `VISIVELMENUPRINCIPAL` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `op`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `op` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `TIPOPROCESSO` varchar(50) NOT NULL DEFAULT '',
  `ORS_SALDO` double(18,8) NOT NULL,
  `JUSTIFICATIVANAOPROGRAMAVEL` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `oparquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oparquivos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ID_ARQUIVO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `APROVADO` char(1) NOT NULL DEFAULT '',
  `DATA_APROVACAO` datetime DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LOCALIZACAOARQUIVO` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ID_ARQUIVO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `operador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operador` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOME` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCARGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOSETOR` int(11) NOT NULL DEFAULT '0',
  `CODIGOTURNO1` int(11) DEFAULT NULL,
  `CODIGOTURNO2` int(11) DEFAULT NULL,
  `CODIGOTURNO3` int(11) DEFAULT NULL,
  `OBSERVACOES` longtext,
  `DESATIVADO` char(1) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) DEFAULT NULL,
  `DATAADMISSAO` date DEFAULT NULL,
  `DATADEMISSAO` date DEFAULT NULL,
  `HORASTRABMENSAL` int(11) DEFAULT NULL,
  `HORASTRABEXTRAS` int(11) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCargo` (`EMP_ID`,`CODIGOCARGO`),
  KEY `fkSEtor` (`EMP_ID`,`CODIGOSETOR`),
  KEY `fkTurno1` (`EMP_ID`,`CODIGOTURNO1`),
  KEY `fkTurno2` (`EMP_ID`,`CODIGOTURNO2`),
  KEY `fkTurno3` (`EMP_ID`,`CODIGOTURNO3`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `operadorauxiliar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operadorauxiliar` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOOPERADOR` int(11) NOT NULL DEFAULT '0',
  `CODIGOOPERADORAUX` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOOPERADOR`,`CODIGOOPERADORAUX`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOperador` (`EMP_ID`,`CODIGOOPERADOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `operadorlogterminal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operadorlogterminal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOOPERADOR` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEOPERADOR` varchar(50) NOT NULL DEFAULT '',
  `STATUS` char(1) NOT NULL DEFAULT '',
  `DATA` datetime DEFAULT NULL,
  `HORA` time DEFAULT NULL,
  `CODIGOTURNO1` int(11) DEFAULT NULL,
  `DESCRICAOTURNO1` varchar(50) DEFAULT NULL,
  `CODIGOTURNO2` int(11) DEFAULT NULL,
  `DESCRICAOTURNO2` varchar(50) DEFAULT NULL,
  `CODIGOTURNO3` int(11) DEFAULT NULL,
  `DESCRICAOTURNO3` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOOPERADOR`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOperador` (`EMP_ID`,`CODIGOOPERADOR`),
  KEY `fkTurno1` (`EMP_ID`,`CODIGOTURNO1`),
  KEY `fkTurno2` (`EMP_ID`,`CODIGOTURNO2`),
  KEY `fkTurno3` (`EMP_ID`,`CODIGOTURNO3`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOTIPOIMPRESSO` varchar(30) NOT NULL,
  `ORS_DESCRICAO` longtext,
  `ORS_DATA` datetime DEFAULT NULL,
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGOVENDEDOR` varchar(20) NOT NULL DEFAULT '',
  `CODIGOFORMAPAGTO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOENDERECO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOCONTATO` varchar(20) NOT NULL DEFAULT '',
  `CODIGOQUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `TIPOIMPOSTO` varchar(20) NOT NULL DEFAULT '0',
  `UNIDADEORCAMENTO` varchar(50) DEFAULT NULL,
  `ORS_QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `OBSERVACAO` longtext,
  `PERCICMS` double(18,8) NOT NULL,
  `PERCISS` double(18,8) NOT NULL,
  `PERCIPI` double(18,8) NOT NULL,
  `VALORCUSTO` double(18,8) NOT NULL,
  `PERCMARGEMLUCRO` double(18,8) NOT NULL,
  `VALORMARGEMLUCRO` double(18,8) NOT NULL,
  `PERCCONTRIBMARGINAL` double(18,8) NOT NULL,
  `VALORCONTRIBMARGINAL` double(18,8) NOT NULL,
  `VALORCONTRIBMARGINALSEMLUCRO` double(18,8) NOT NULL,
  `PERCCOMVENDEDOR` double(18,8) NOT NULL,
  `VALORCOMVENDEDOR` double(18,8) NOT NULL,
  `PERCCOMAGENCIA` double(18,8) NOT NULL,
  `VALORCOMAGENCIA` double(18,8) NOT NULL,
  `PERCIMPOSTOS` double(18,8) NOT NULL,
  `VALORIMPOSTOS` double(18,8) NOT NULL,
  `VALORUNITVISTA` double(18,8) NOT NULL,
  `VALORTOTALVISTA` double(18,8) NOT NULL,
  `VALORUNITPRAZO` double(18,8) NOT NULL,
  `VALORTOTALPRAZO` double(18,8) NOT NULL,
  `VALORTOTACERTOIMP` double(18,8) NOT NULL,
  `TEMPOTOTACERTOIMP` int(11) NOT NULL DEFAULT '0',
  `VALORTOTLIMPEZAIMP` double(18,8) NOT NULL,
  `TEMPOTOTLIMPEZAIMP` int(11) NOT NULL DEFAULT '0',
  `VALORTOTIMPRESSAO` double(18,8) NOT NULL,
  `TEMPOTOTIMPRESSAO` int(11) NOT NULL DEFAULT '0',
  `VALORTOTPAPELML` double(18,8) NOT NULL,
  `QTTOTPAPELML` double(18,8) NOT NULL,
  `VALORTOTACERTOACAB` double(18,8) NOT NULL,
  `TEMPOTOTACERTOACAB` int(11) NOT NULL DEFAULT '0',
  `VALORTOTLIMPEZAACAB` double(18,8) NOT NULL,
  `TEMPOTOTLIMPEZAACAB` int(11) NOT NULL DEFAULT '0',
  `VALORTOTACABAMENTO` double(18,8) NOT NULL,
  `TEMPOTOTACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `QTTOTSERVICOS` double(18,8) NOT NULL,
  `VALORTOTSERVICOS` double(18,8) NOT NULL,
  `QTTOTFACAS` double(18,8) NOT NULL,
  `VALORTOTFACAS` double(18,8) NOT NULL,
  `QTTOTTINTAS` double(18,8) NOT NULL,
  `VALORTOTTINTAS` double(18,8) NOT NULL,
  `ORS_CANCELADA` char(1) NOT NULL DEFAULT '',
  `QUANTIDADECOMERCIAL` double(18,8) NOT NULL,
  `VALORUNITCOMERCIAL` double(18,8) NOT NULL,
  `VALORUNITVISTACOMERCIAL` double(18,8) NOT NULL,
  `ORS_PRODUCAO` char(1) NOT NULL,
  `ORS_STATUSFATURAMENTO` varchar(20) NOT NULL,
  `PCPCODIGOSTATUSOP` int(11) NOT NULL,
  `FATORCONVERSAO` double(18,8) NOT NULL,
  `CODPERFILIMPOSTO` int(11) DEFAULT NULL,
  `NUMEROPEDIDO` varchar(50) DEFAULT NULL,
  `ORS_CLASSIFICACAO` char(2) DEFAULT NULL,
  `OS_INFOFATURAMENTO` longtext,
  `ORS_ORDEMCOMPRA` varchar(20) DEFAULT NULL,
  `VLR_CUSTO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor de custo realizado',
  `PER_MARGEMLUCRO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentua de margem de lucro realizada',
  `VLR_MARGEMLUCRO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da margem de lucro realizada',
  `PER_CONTRIMARGINAL_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentual de contribuição marginal realizada',
  `VLR_CONTRIMARGINAL_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da contribuição marginal realizada',
  `PER_COMISSAO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentual de comissão reaalizada',
  `VLR_COMISSAO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da comissão realizada',
  `VLR_IMPOSTO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor do imposto realizado',
  `VLR_TOTAL_REALIZADO` double(18,8) DEFAULT '0.00000000',
  `TIPOVLRPOSCALC` varchar(30) DEFAULT NULL,
  `ORS_DATALIBERACAOFAT` date DEFAULT NULL,
  `CST` varchar(5) DEFAULT NULL,
  `CODIGONCM` varchar(20) DEFAULT NULL,
  `CSTIPI` varchar(20) DEFAULT NULL,
  `CSTPIS` varchar(20) DEFAULT NULL,
  `CSTCOFINS` varchar(20) DEFAULT NULL,
  `CNAE` varchar(10) DEFAULT NULL,
  `ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `ORS_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGOVENDEDOR`),
  KEY `fkFormaPagto` (`EMP_ID`,`CODIGOFORMAPAGTO`),
  KEY `fkEndereco` (`EMP_ID`,`CLI_ID`,`CODIGOENDERECO`),
  KEY `fkContato` (`EMP_ID`,`CLI_ID`,`CODIGOCONTATO`),
  KEY `fkFlexoQtde` (`EMP_ID`,`CODIGOQUANTIDADE`),
  KEY `fkPCPCodigoStatusOP` (`EMP_ID`,`PCPCODIGOSTATUSOP`),
  KEY `fkPerfilImposto` (`EMP_ID`,`CODPERFILIMPOSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponente` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `BOBINALARGURA` double(18,8) NOT NULL,
  `BOBINAALTURA` double(18,8) NOT NULL,
  `MEDFINALLARGURA` double(18,8) NOT NULL,
  `MEDFINALALTURA` double(18,8) NOT NULL,
  `CARREIRA` double(18,8) NOT NULL,
  `CODIGOCLICHE` int(11) NOT NULL DEFAULT '0',
  `CODIGOFACAPRINCIPAL` int(11) NOT NULL DEFAULT '0',
  `TIPOLAMINA` varchar(50) DEFAULT NULL,
  `CODIGOMAQUNA` int(11) NOT NULL DEFAULT '0',
  `TIRAGEM` int(11) NOT NULL DEFAULT '0',
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLAVACAO` int(11) NOT NULL DEFAULT '0',
  `TEMPOIMPRESSAO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `BOBINACORTE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `REPETICAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ESPACOABA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `COLUNAVERTICAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `COLUNADIAGONAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `TIRAGEMMAQUINA` int(10) NOT NULL,
  `VALORHORAIMPRESSAO` double(18,8) NOT NULL,
  `VALORIMPRESSAO` double(18,8) NOT NULL,
  `VALORACERTO` double(18,8) NOT NULL,
  `VALORLIMPEZA` double(18,8) NOT NULL,
  `VALORHORAOPERADOR` double(18,8) NOT NULL,
  `TEMPOACERTOMAQ` int(11) NOT NULL,
  `VALORTOTALLAVACAO` double(18,8) NOT NULL,
  `VALORTOTALACERTO` double(18,8) NOT NULL,
  `QTLAVACAO` int(11) NOT NULL,
  `QTACERTO` int(11) NOT NULL,
  `QUANTIDADEETIQUETAS` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoCliche` (`EMP_ID`,`CODIGOCLICHE`),
  KEY `fkFlexoFaca` (`EMP_ID`,`CODIGOFACAPRINCIPAL`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQUNA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponentebobina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponentebobina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOBOBINA` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PRINCIPAL` int(11) NOT NULL DEFAULT '0',
  `VALOR` double(18,8) NOT NULL,
  `FATORABSORCAO` double(18,8) NOT NULL,
  `LARGURA` double(18,8) NOT NULL,
  `PRECO` double(18,8) NOT NULL,
  `PRECOM2` double(18,8) NOT NULL,
  `QUANTIDADEPAPELML` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QUANTIDADEPAPELM2` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QUANTIDADEPAPELIMPRESSAOML` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QUANTIDADEPAPELPERDAML` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QUANTIDADEPAPELACERTOML` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOBOBINA`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoComponente` (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponentefaca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponentefaca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOFACA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOFACA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoFaca` (`EMP_ID`,`CODIGOFACA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponentemaqacab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponentemaqacab` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTACERTO` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADE` double(18,8) NOT NULL,
  `MONTAGEM` double(18,8) NOT NULL,
  `VALORMAQUINA` double(18,8) NOT NULL,
  `TEMPOACERTO` int(11) NOT NULL DEFAULT '0',
  `TEMPOLIMPEZA` int(11) NOT NULL DEFAULT '0',
  `TEMPOMINIMO` int(11) NOT NULL DEFAULT '0',
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIRAGEMMAQUINA` int(11) NOT NULL DEFAULT '0',
  `TEMPOACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `VALORTOTAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOMAQACABAMENTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQACABAMENTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponentemaqacabmatprimaqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponentemaqacabmatprimaqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOMAQACABAMENTO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(30) NOT NULL,
  `VALORTOTAL` double NOT NULL,
  `QUANTIDADETOTAL` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOMAQACABAMENTO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoMaquina` (`EMP_ID`,`CODIGOMAQACABAMENTO`),
  KEY `fkFlexoMaterial` (`EMP_ID`,`MTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponenteservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponenteservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOSERVICO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORMINIMO` double(18,8) NOT NULL,
  `TIPOCALCULO` varchar(50) DEFAULT NULL,
  `TIPOSERVICO` varchar(50) DEFAULT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOSERVICO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoServico` (`EMP_ID`,`CODIGOSERVICO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexocomponentetinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexocomponentetinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOTINTA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PERCAREAFRENTE` double(18,8) NOT NULL,
  `PERCAREAVERSO` double(18,8) NOT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `FATORABSORCAO` double(18,8) NOT NULL,
  `QTDTINTA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOCOMPONENTE`,`CODIGOTINTA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoTinta` (`EMP_ID`,`CODIGOTINTA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexolocalentrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexolocalentrega` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORS_LOCALENTREGADIFDESTINO` char(1) NOT NULL,
  `ORS_CNPJCPFDESTINO` varchar(14) DEFAULT NULL,
  `ORS_LOGRADOURODESTINO` varchar(60) DEFAULT NULL,
  `ORS_NUMERODESTINO` varchar(60) DEFAULT NULL,
  `ORS_COMPLEMENTODESTINO` varchar(60) DEFAULT NULL,
  `ORS_BAIRRODESTINO` varchar(60) DEFAULT NULL,
  `ORS_CODIGOMUNICIPIODESTINO` int(11) DEFAULT NULL,
  `ORS_SIGLAUFDESTINO` char(2) DEFAULT NULL,
  `ORS_CODIGOENDDIFENTREGA` int(11) DEFAULT NULL,
  `ORS_CONTATO` varchar(100) DEFAULT NULL,
  `ORS_MODALIDADEFRETE` varchar(20) DEFAULT '',
  `ORS_CODIGOTRANSPORTADORA` varchar(20) DEFAULT '',
  `ORS_CEPDESTINO` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexomaterial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexomaterial` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `PRECOCUSTO` double(18,8) NOT NULL,
  `PRECOTOTAL` double(18,8) NOT NULL,
  `QUANTIDADETOTAL` double(18,8) NOT NULL,
  `QUANTIDADECALCULADA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`MTR_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexomodelo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexomodelo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOORCAMENTO` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOMODELO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAOMODELO` varchar(150) NOT NULL DEFAULT '',
  `QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `ORDEMCOMPRA` varchar(20) DEFAULT NULL,
  `METROSPEDIDOS` double(18,8) NOT NULL,
  `METROSEFETIVOS` double(18,8) NOT NULL,
  `QUANTIDADEEFETIVA` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADEFINAL` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADEPERDA` int(11) NOT NULL DEFAULT '0',
  `QUANTIDADEBAIXADA` int(11) NOT NULL DEFAULT '0',
  `METRAGEMFINAL` double(18,8) NOT NULL,
  `PERDAMETROS` double(18,8) NOT NULL,
  `SALDOOPMODELOS` int(11) NOT NULL DEFAULT '0',
  `DATAENTREGA` datetime DEFAULT NULL,
  `ORIGEMITEM` char(1) DEFAULT NULL,
  `CODIGOITEM` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGOORCAMENTO`,`CODIGOMODELO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkFlexoOrc` (`EMP_ID`,`CODIGOORCAMENTO`),
  KEY `fkFlexoModelo` (`EMP_ID`,`CODIGOORCAMENTO`,`CODIGOMODELO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexoobservacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexoobservacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OBSERVACAO` longtext,
  `OBSERVACAOADICIONAL` longtext,
  `OBSERVACAOINTERNA` longtext,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexoplanejamentoentrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexoplanejamentoentrega` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `PLE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PLE_QTENTREGA` int(11) NOT NULL DEFAULT '0',
  `PLE_QTENTREGAESTOQUE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `PLE_DATAENTREGA` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ORIGEM` varchar(30) NOT NULL,
  `CODIGOITEM` varchar(30) NOT NULL,
  `PLE_DESCRICAOFATITEM` varchar(1000) NOT NULL,
  `SALDOPRODUZIR` double(18,8) NOT NULL,
  `SALDOPRODUZIRESTOQUE` double(18,8) NOT NULL,
  `SALDOFATURAR` double(18,8) NOT NULL,
  `FATORCONVERSAO` double(18,8) NOT NULL,
  `MOD_ID` int(11) DEFAULT NULL,
  `ORIGEMVALORFATURAMENTO` varchar(30) NOT NULL,
  `NUMEROORDEMCOMPRA` varchar(15) DEFAULT NULL,
  `NUMEROITEMORDEMCOMPRA` int(6) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`PLE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opflexovendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opflexovendedor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0',
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEVENDEDOR` varchar(50) NOT NULL DEFAULT '',
  `PERCCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOPFlexo` (`EMP_ID`,`ORS_ID`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opproduto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opproduto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_OPPRODUTO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOOP` varchar(20) NOT NULL,
  `CODIGOPRODUTO` varchar(20) NOT NULL,
  `DATABAIXA` datetime NOT NULL,
  `CODIGOLOTEPROD` varchar(40) DEFAULT NULL,
  `QTDBAIXADA` double(18,8) NOT NULL,
  `QTDBAIXADAESTOQUE` double(18,8) NOT NULL,
  `CODIGOTIPOLOTE` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(30) NOT NULL,
  `CANCELADA` char(1) DEFAULT NULL,
  `IDPLANEJAMENTOOP` int(11) DEFAULT NULL,
  `TIPOBAIXA` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_OPPRODUTO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkProduto` (`EMP_ID`,`CODIGOPRODUTO`),
  KEY `fkLoteProduto` (`EMP_ID`,`CODIGOLOTEPROD`,`CODIGOPRODUTO`),
  KEY `fkTipoLote` (`EMP_ID`,`CODIGOPRODUTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akCodigoOP` (`EMP_ID`,`CODIGOOP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `opsisterceiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opsisterceiros` (
  `EMP_ID` int(11) NOT NULL,
  `NUMEROOP` varchar(30) NOT NULL,
  `CODCLIENTE` varchar(30) DEFAULT NULL,
  `NOMECLIENTE` varchar(100) DEFAULT NULL,
  `FONECLIENTE` varchar(15) DEFAULT NULL,
  `CONTATO` varchar(100) DEFAULT NULL,
  `CODVENDEDOR` varchar(100) DEFAULT NULL,
  `NOMEVENDEDOR` varchar(100) DEFAULT NULL,
  `DESCRICAO` longtext,
  `QUANTIDADE` int(11) DEFAULT NULL,
  `TIPOSERVICO` varchar(100) DEFAULT NULL,
  `TITULO` varchar(100) DEFAULT NULL,
  `VALORVENDA` double(18,8) DEFAULT NULL,
  `PRAZOPAGTO` varchar(50) DEFAULT NULL,
  `CONTRIBUICAOMARG` double(18,8) DEFAULT NULL,
  `PERCMAGEMLUCRO` double(18,8) DEFAULT NULL,
  `VALORCUSTO` double(18,8) DEFAULT NULL,
  `PERCCOMISSAOVEND` double(18,8) DEFAULT NULL,
  `PERCCOMISSAOAGENCIA` double(18,8) DEFAULT NULL,
  `PERCCOMISSAOESPECIAL` double(18,8) DEFAULT NULL,
  `PERCCOMISSAOINTERNA` double(18,8) DEFAULT NULL,
  `DATAEMISSAO` date DEFAULT NULL,
  `USUARIOEMISSAO` varchar(50) DEFAULT NULL,
  `DATAPREVISAOCLIENTE` date DEFAULT NULL,
  `USUARIOBAIXA` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`NUMEROOP`,`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOPROCESSO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ORC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcagencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcagencia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORA_PERCCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORC_DTORCAMENTO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ORC_DTVALIDADEORC` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ORC_DESCRICAO` longtext NOT NULL,
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `CLI_DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `CLI_CIDADE` varchar(50) NOT NULL DEFAULT '',
  `CLI_FONE` varchar(12) NOT NULL DEFAULT '',
  `CLI_RESPONSAVEL` varchar(50) NOT NULL DEFAULT '',
  `CLI_UF` char(2) NOT NULL DEFAULT '',
  `PERC_ICMS` double(18,8) NOT NULL,
  `VEN_ID` varchar(20) NOT NULL DEFAULT '',
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `VEN_PERCCOMISSAO` double(18,8) NOT NULL,
  `ORC_OBSERVACAO` longtext,
  `MTR_ID` varchar(20) DEFAULT NULL,
  `ORC_VLRCUSTO` double(18,8) NOT NULL,
  `ORC_MEDALTURA` double(18,8) NOT NULL,
  `ORC_MEDLARGURA` double(18,8) NOT NULL,
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_QTJOGOSPAGINAS` int(11) DEFAULT NULL,
  `ORC_PRODUTOSERVICO` varchar(20) NOT NULL DEFAULT '',
  `ORC_PROPOSTA` char(1) NOT NULL DEFAULT '',
  `ORC_ORDEMSERVICO` char(1) NOT NULL DEFAULT '',
  `ORC_PADRAO` char(1) NOT NULL DEFAULT '',
  `ORC_TIPOVALORPAPEL` varchar(20) NOT NULL DEFAULT '',
  `ORC_NROVIAS` int(11) DEFAULT NULL,
  `NUMEROCONTRATO` varchar(20) DEFAULT NULL,
  `TPI_TIPOIMPRESSO` varchar(20) NOT NULL DEFAULT '',
  `GI_ID` varchar(20) DEFAULT NULL,
  `ORC_CREDITAPISCOFINS` char(1) DEFAULT NULL,
  `END_ID` int(11) DEFAULT NULL,
  `CON_ID` int(11) DEFAULT NULL,
  `ORC_VERIFICAPINCA` char(1) DEFAULT NULL,
  `CLI_LOGRADOURO` varchar(100) DEFAULT NULL,
  `NOMEUSUARIO` varchar(50) DEFAULT NULL,
  `LOGINUSUARIO` varchar(50) DEFAULT NULL,
  `ULTIMONOMEUSUARIO` varchar(50) DEFAULT NULL,
  `ULTIMOLOGINUSUARIO` varchar(50) DEFAULT NULL,
  `ORCIDMESTRE` varchar(20) DEFAULT NULL,
  `PERC_ICMSREVENDA` double(18,8) NOT NULL,
  `GERADESCRICAOAUT` char(1) DEFAULT NULL,
  `ORC_CODIGONCM` varchar(20) DEFAULT NULL,
  `ORC_COPIAROBSOP` char(1) NOT NULL DEFAULT '',
  `ORC_CLACOMPRIMENTO` double(18,8) NOT NULL,
  `ORC_CLAALTURA` double(18,8) NOT NULL,
  `ORC_CLALARGURA` double(18,8) NOT NULL,
  `ORC_NEGOCIACAOFINALIZADA` char(1) DEFAULT NULL,
  `OBSERVACAOPOSCALCULO` longblob,
  `ORC_CSTICMS` varchar(20) DEFAULT NULL,
  `ORC_CSTIPI` varchar(20) DEFAULT NULL,
  `ORC_CSTPIS` varchar(20) DEFAULT NULL,
  `ORC_CSTCOFINS` varchar(20) DEFAULT NULL,
  `ORC_CNAE` varchar(10) DEFAULT NULL,
  `ORC_CLAALTURAABERTO` double(18,8) NOT NULL,
  `ORC_CLALARGURAABERTO` double(18,8) NOT NULL,
  `ORC_DEFINIRVLRUNITMANUAL` char(1) NOT NULL DEFAULT 'N',
  `ORC_VLRUNITARIOMANUAL` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LTP_ID` varchar(20) NOT NULL,
  `CODPERFILIMPOSTO` int(11) DEFAULT NULL,
  `ORC_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `ORC_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `ORC_USARLISTAPRECO` char(1) NOT NULL,
  `ORC_CREDITAICMSIPI` char(1) DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `COMISSAOMANUAL` char(1) NOT NULL,
  `ORC_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `ORC_TITULO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkGrupoImpressao` (`EMP_ID`,`GI_ID`),
  KEY `fkEndereco` (`EMP_ID`,`CLI_ID`,`END_ID`),
  KEY `fkContato` (`EMP_ID`,`CLI_ID`,`CON_ID`),
  KEY `fkListaPreco` (`EMP_ID`,`LTP_ID`),
  KEY `fkPerfilImposto` (`EMP_ID`,`CODPERFILIMPOSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcamentolog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcamentolog` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA` datetime DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `TEXTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcamentoservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcamentoservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `TPS_INFORMATIVO` varchar(10) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSR_NAOINCDESCAUTORC` char(1) NOT NULL DEFAULT '',
  `OSR_TIPOVLRMINIMO` varchar(20) NOT NULL DEFAULT '',
  `OSR_VLRFRETE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OSR_OBSERVACAO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`TPS_INFORMATIVO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcamentoservicomatdiv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcamentoservicomatdiv` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOR_IDQUANT` int(11) NOT NULL DEFAULT '0',
  `FOR_IDVALOR` int(11) NOT NULL DEFAULT '0',
  `OSMD_VLRUNITARIO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`MTR_ID`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServico` (`EMP_ID`,`ORC_ID`,`OSR_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormula1` (`FOR_IDQUANT`),
  KEY `fkFormula2` (`FOR_IDVALOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orclamina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orclamina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORL_TIPOLAMINA` varchar(20) NOT NULL DEFAULT '',
  `ORL_GRAMATURAPAPEL` double(18,8) NOT NULL,
  `ORL_QTCORFRENTE` int(11) NOT NULL DEFAULT '0',
  `ORL_QTCORVERSO` int(11) NOT NULL DEFAULT '0',
  `ORL_MEDLARGLAMINA` double(18,8) NOT NULL,
  `ORL_MEDALTURALAMINA` double(18,8) NOT NULL,
  `ORL_MEDORELHA` double(18,8) DEFAULT NULL,
  `ORL_COBRACHAPA` char(1) NOT NULL DEFAULT '',
  `ORL_COBRAACERTO` char(1) NOT NULL DEFAULT '',
  `ORL_COBRALAVACAO` char(1) NOT NULL DEFAULT '',
  `ORL_COBRALAVACAOVERSO` char(1) NOT NULL DEFAULT '',
  `ORL_CHAPAADIC` int(11) DEFAULT NULL,
  `ORL_ACERTOADIC` int(11) DEFAULT NULL,
  `ORL_LAVACAOADIC` int(11) DEFAULT NULL,
  `ORL_MEDSANGRIA` double(18,8) NOT NULL,
  `ORL_NROPAGINAS` int(11) NOT NULL DEFAULT '0',
  `TPP_ID` int(11) NOT NULL DEFAULT '0',
  `ORL_DESCRICAO` varchar(20) NOT NULL DEFAULT '',
  `ORL_PERCINDESTPAPEL` double(18,8) NOT NULL,
  `ORL_QTLAMINAS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ORL_CARREIRAS` int(11) DEFAULT NULL,
  `ORL_REPETICOES` int(11) DEFAULT NULL,
  `ORL_FATORMONTAGEMMIOLO` int(10) DEFAULT NULL,
  `GI_ID` varchar(20) DEFAULT NULL,
  `ORL_VERNIZEMLINHA` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkPapel` (`EMP_ID`,`TPP_ID`),
  KEY `fkGrupoImpressao` (`EMP_ID`,`GI_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orclamtinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orclamtinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `OLT_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `OLT_VLRTINTAUNITARIO` double(18,8) NOT NULL,
  `OLT_TIPOTINTA` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`OLT_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkTinta` (`EMP_ID`,`TIN_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orclamtintaqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orclamtintaqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `OLT_ID` int(11) NOT NULL DEFAULT '0',
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OTQ_QTTINTA` double(18,8) NOT NULL,
  `OTQ_VLRTINTA` double(18,8) NOT NULL,
  `OTQ_VLRTINTAUNITARIO` double(18,8) NOT NULL,
  `OTQ_PERCAREAFRENTE` double(18,8) NOT NULL,
  `OTQ_PERCAREAVERSO` double(18,8) NOT NULL,
  `OTQ_TIPOTINTA` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`OLT_ID`,`TIN_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkOrcLamTinta` (`EMP_ID`,`ORC_ID`,`ORL_ID`,`OLT_ID`,`TIN_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacab` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPA_INFORMATIVO` varchar(10) NOT NULL DEFAULT '',
  `MAQ_OBSERVACAO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacablamina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacablamina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MAQ_ID`,`ORL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacablaminaparametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacablaminaparametros` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEPARAMETRO` varchar(50) NOT NULL,
  `VALORPARAMETRO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MAQ_ID`,`ORL_ID`,`ID_SCRIPT`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacablaminaquant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacablaminaquant` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OLM_QUANTIDADE` double(18,8) NOT NULL,
  `OLM_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `OLM_VALOR` double(18,8) NOT NULL,
  `OLM_TEMPO` double(18,8) NOT NULL,
  `OLM_COBRAACERTO` char(1) NOT NULL DEFAULT '',
  `OLM_QTACERTOCOBRAR` int(11) NOT NULL DEFAULT '0',
  `OLM_VALORTOTALMATPRIMA` double(18,8) NOT NULL,
  `OLM_TEMPOACABAMENTO` double(18,8) NOT NULL,
  `OLM_TEMPOACERTO` double(18,8) NOT NULL,
  `OLM_TEMPOEXECUCAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_BASEARPRODMAQACAB` int(11) NOT NULL DEFAULT '0',
  `OLM_TIPOTIRAGEMMAQACAB` varchar(20) NOT NULL DEFAULT '',
  `OLM_VLRHRMAQACAB` double(18,8) NOT NULL,
  `OLM_PRIMILHEIROMAQACAB` double(18,8) NOT NULL,
  `OLM_DEMMILHEIROSMAQACAB` double(18,8) NOT NULL,
  `OLM_QTPEDACOSMAQACAB` int(11) NOT NULL DEFAULT '0',
  `OLM_TEMPOUSOMINMAQACAB` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_TEMPOACERTOMAQACAB` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_FORMULAMAQACAB` int(11) NOT NULL DEFAULT '0',
  `OLM_TIRAGEMMAQUINA` int(10) NOT NULL DEFAULT '0',
  `OLM_TEMPOACABLP` double(18,8) NOT NULL,
  `OLM_VALORACABLP` double(18,8) NOT NULL,
  `OLM_FATORACERTOPROD` int(11) NOT NULL,
  `OLM_TIPOMEDCALC` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`QTO_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacabmatprima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacabmatprima` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTCONSUMO` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `UNIDADECONSUMO` varchar(10) NOT NULL DEFAULT '',
  `QTMINIMACONSUMO` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `MTR_ID` varchar(30) DEFAULT '0',
  `CALCULAUSANDOFORMULA` char(1) NOT NULL DEFAULT '',
  `CODIGOFORMULA` int(11) NOT NULL DEFAULT '0',
  `FOR_IDQUANT` int(11) NOT NULL DEFAULT '0',
  `FOR_IDVALOR` int(11) NOT NULL DEFAULT '0',
  `QTCONSUMO2` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MAQ_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormula1` (`CODIGOFORMULA`),
  KEY `fkFormula2` (`FOR_IDQUANT`),
  KEY `fkFormula3` (`FOR_IDVALOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmaqacabmatprimalaminaquant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmaqacabmatprimalaminaquant` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTCONSUMO` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `UNIDADECONSUMO` varchar(10) NOT NULL DEFAULT '',
  `QTMINIMACONSUMO` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `PERCVERNIZ` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `MTR_ID` varchar(30) DEFAULT NULL,
  `QUANTIDADELP` double(18,8) NOT NULL,
  `VALORTOTALLP` double(18,8) NOT NULL,
  `QTCONSUMO2` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`QTO_ID`,`MAQ_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmatdiversos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmatdiversos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_QT` double(18,8) NOT NULL,
  `UN_CONSUMO` varchar(10) NOT NULL DEFAULT '',
  `MTR_PRECOCUSTO` double(18,8) NOT NULL,
  `MTR_PRECOTOTAL` double(18,8) NOT NULL,
  `MTR_QTLP` double(18,8) NOT NULL,
  `MTR_PRECOTOTALLP` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MTR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmtdiverso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmtdiverso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `MTDIV_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTDIV_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `MTDIV_UNCONSUMO` varchar(10) NOT NULL DEFAULT '',
  `MTR_PRECOCUSTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`MTDIV_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTDIV_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcmtdiversoqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcmtdiversoqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `MTDIV_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTDIV_QT` double(18,8) NOT NULL,
  `MTDIV_PRECOCUSTO` double(18,8) NOT NULL,
  `MTDIV_PRECOTOTAL` double(18,8) NOT NULL,
  `MTDIV_QTORCAMENTO` int(11) NOT NULL DEFAULT '0',
  `MTDIV_MONTAGEM` double(18,8) NOT NULL,
  `MTDIV_QTLP` double(18,8) NOT NULL,
  `MTDIV_PRECOTOTALLP` double(18,8) NOT NULL,
  `MTDIV_QTCALCULADA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`QTO_ID`,`MTDIV_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTDIV_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcprodutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcprodutor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PRO_PERCCOMISSAO` double(18,8) NOT NULL,
  `PES_IDPAIAGENCIA` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkProdutor` (`EMP_ID`,`PES_ID`),
  KEY `fkProdPai` (`EMP_ID`,`PES_IDPAIAGENCIA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSR_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `OSR_VLRUNITARIO` double(18,8) NOT NULL,
  `OSR_VLRMINIMO` double(18,8) NOT NULL,
  `OSR_TIPOSERVICO` varchar(10) NOT NULL DEFAULT '',
  `FOR_ID` int(11) NOT NULL DEFAULT '0',
  `OSR_INFORMARVALORES` char(1) NOT NULL DEFAULT '',
  `OSR_SERVICOGERAL` char(1) NOT NULL DEFAULT '',
  `OSR_TIPOCALCULO` int(11) NOT NULL DEFAULT '0',
  `OSR_TIPOVLRMINIMO` varchar(20) NOT NULL DEFAULT '',
  `OSR_NAOINCDESCAUTORC` char(1) NOT NULL DEFAULT '',
  `OSR_TEMPOEXEC` int(11) DEFAULT NULL,
  `OSR_DESATIVADO` char(1) NOT NULL DEFAULT 'N',
  `OSR_QTDPEDACOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `IDENT_ID` int(11) DEFAULT NULL,
  `OSR_OBSERVACAO` longtext,
  `OSR_OBSOPOBRIGATORIA` char(1) DEFAULT 'N' COMMENT 'Observação da OP obrigatória',
  `OSR_VLRFRETE` double(18,8) NOT NULL,
  `OSR_APELIDO` varchar(50) DEFAULT '',
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `OSR_OBSORCOBRIGATORIA` char(1) DEFAULT 'N',
  `ID_SCRIPT` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`OSR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`OSR_ID`),
  KEY `fkFormula` (`FOR_ID`),
  KEY `fkIdentCusto` (`EMP_ID`,`IDENT_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicogeral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicogeral` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSG_QUANTIDADE` double(18,8) NOT NULL,
  `OSG_VLRUNIT` double(18,8) NOT NULL,
  `OSG_VLRTOTAL` double(18,8) NOT NULL,
  `OSR_NAOINCDESCAUTORC` char(1) NOT NULL DEFAULT '',
  `OSR_TIPOVLRMINIMO` varchar(20) NOT NULL DEFAULT '',
  `OSR_QTPEDACOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OSG_QUANTIDADELP` double(18,8) NOT NULL,
  `OSG_VLRTOTALLP` double(18,8) NOT NULL,
  `OSG_OBSERVACAO` longtext,
  `OSG_VLRFRETE` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicogeralparametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicogeralparametros` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEPARAMETRO` varchar(50) NOT NULL,
  `VALORPARAMETRO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`ID_SCRIPT`,`SEQUENCIAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicolamina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicolamina` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`ORL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicolaminaparametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicolaminaparametros` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEPARAMETRO` varchar(50) NOT NULL,
  `VALORPARAMETRO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`ORL_ID`,`ID_SCRIPT`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkServico` (`EMP_ID`,`OSR_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicolaminaquant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicolaminaquant` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OLS_QUANTIDADE` double(18,8) NOT NULL,
  `OLS_VLRUNITARIO` double(18,8) NOT NULL,
  `OLS_QTTOTAL` double(18,8) NOT NULL,
  `OLS_VLRTOTAL` double(18,8) NOT NULL,
  `OLS_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `OSR_NAOINCDESCAUTORC` char(1) NOT NULL DEFAULT '',
  `OSR_TIPOVLRMINIMO` varchar(20) NOT NULL DEFAULT '',
  `FOR_FORMULA` longtext,
  `OSR_VLRMINIMO` float NOT NULL,
  `OSR_QTDPEDACOS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLS_QTTOTALLP` double(18,8) NOT NULL,
  `OLS_VLRTOTALLP` double(18,8) NOT NULL,
  `OLS_VLRFRETE` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`ORL_ID`,`QTO_ID`,`OSR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicomatdivgerlamqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicomatdivgerlamqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSG_QUANTIDADE` double(18,8) NOT NULL,
  `OSG_VALOR` double(18,8) NOT NULL,
  `OSG_QUANTIDADELP` double(18,8) NOT NULL,
  `OSG_VALORLP` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`MTR_ID`,`QTO_ID`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservicomatdivlamqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservicomatdivlamqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSM_QUANTIDADE` double(18,8) NOT NULL,
  `OSM_VALOR` double(18,8) NOT NULL,
  `OSM_QUANTIDADELP` double(18,8) NOT NULL,
  `OSM_VALORLP` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`OSR_ID`,`MTR_ID`,`ORL_ID`,`QTO_ID`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`ORC_ID`,`OSR_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orcservmatdiversos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orcservmatdiversos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOR_IDQUANT` int(11) NOT NULL DEFAULT '0',
  `FOR_IDVALOR` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`OSR_ID`,`MTR_ID`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormula1` (`FOR_IDQUANT`),
  KEY `fkFormula2` (`FOR_IDVALOR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORS_NUMEROPEDIDO` varchar(40) DEFAULT NULL,
  `ORS_DATA` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `ORS_OBSERVACAO` longtext,
  `VEN_ID` varchar(20) NOT NULL DEFAULT '',
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `END_ID` varchar(20) NOT NULL DEFAULT '',
  `CON_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORS_QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `ORS_QTPAPEL` double(18,8) NOT NULL,
  `ORS_VLRPAPEL` double(18,8) NOT NULL,
  `ORS_QTPAPELPERDA` double(18,8) NOT NULL,
  `ORS_VLRPAPELPERDA` double(18,8) NOT NULL,
  `ORS_QTPAPELACERTO` double(18,8) NOT NULL,
  `ORS_VLRPAPELACERTO` double(18,8) NOT NULL,
  `ORS_TEMPOIMPRESSAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ORS_TIRAGEMIMPRESSAO` double(18,8) NOT NULL,
  `ORS_VLRHORAIMPRESSAO` double(18,8) NOT NULL,
  `ORS_TEMPOLAVACAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ORS_VLRLAVACAO` double(18,8) NOT NULL,
  `ORS_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `ORS_VLRACERTO` double(18,8) NOT NULL,
  `ORS_QTCHAPAS` int(11) NOT NULL DEFAULT '0',
  `ORS_VLRCHAPAS` double(18,8) NOT NULL,
  `ORS_QTTINTA` double(18,8) NOT NULL,
  `ORS_VLRTINTA` double(18,8) NOT NULL,
  `ORS_QTSERVICO` double(18,8) NOT NULL,
  `ORS_VLRSERVICO` double(18,8) NOT NULL,
  `ORS_VLRACABAMENTO` double(18,8) NOT NULL,
  `ORS_VLRCUSTO` double(18,8) NOT NULL,
  `ORS_VLRIMPOSTOS` double(18,8) NOT NULL,
  `ORS_PERCCOMVENDEDOR` double(18,8) NOT NULL,
  `ORS_VLRCOMVENDEDOR` double(18,8) NOT NULL,
  `ORS_PERCCOMAGENCIA` double(18,8) NOT NULL,
  `ORS_VLRCOMAGENCIA` double(18,8) NOT NULL,
  `ORS_PERCMARGEMLUCRO` double(18,8) NOT NULL,
  `ORS_VLRMARGEMLUCRO` double(18,8) NOT NULL,
  `ORS_VLRCONTRIBMARGINAL` double(18,8) NOT NULL,
  `ORS_PERCFORMAPAG` double(18,8) NOT NULL,
  `ORS_VLRFORMAPAG` double(18,8) NOT NULL,
  `ORS_VLRFINALVISTA` double(18,8) NOT NULL,
  `ORS_VLRFINALPRAZO` double(18,8) NOT NULL,
  `ORS_VLRPIS` double(18,8) NOT NULL,
  `ORS_VLRISS` double(18,8) NOT NULL,
  `ORS_VLROUTROS` double(18,8) NOT NULL,
  `ORS_VLRCOFINS` double(18,8) NOT NULL,
  `ORS_VLRTAXAADM` double(18,8) NOT NULL,
  `ORS_VLRIMPOSTORENDA` double(18,8) NOT NULL,
  `ORS_VLRSIMPLESFEDERAL` double(18,8) NOT NULL,
  `ORS_VLRICMS` double(18,8) NOT NULL,
  `ORS_VLRIPI` double(18,8) NOT NULL,
  `ORS_VLRUNITPRAZO` double(18,8) NOT NULL,
  `ORS_VLRUNITVISTA` double(18,8) NOT NULL,
  `ORS_VLRSERVICOGERAL` double(18,8) NOT NULL,
  `ORS_PERCCONTRIBMARG` double(18,8) NOT NULL,
  `ORS_PERCISS` double(18,8) NOT NULL,
  `ORS_PERCICMS` double(18,8) NOT NULL,
  `ORS_PERCIPI` double(18,8) NOT NULL,
  `ORS_PERCPIS` double(18,8) NOT NULL,
  `ORS_PERCOUTROS` double(18,8) NOT NULL,
  `ORS_PERCCOFINS` double(18,8) NOT NULL,
  `ORS_PERCTAXAADMIN` double(18,8) NOT NULL,
  `ORS_PERCIMPRENDA` double(18,8) NOT NULL,
  `ORS_PERCSIMPLESFEDERAL` double(18,8) NOT NULL,
  `ORS_CALCULAISS` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULAICMS` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULAIPI` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULAPIS` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULACOFINS` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULASIMPLESFEDERAL` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULAIMPOSTORENDA` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULATAXAADM` char(1) NOT NULL DEFAULT '',
  `ORS_CALCULAOUTROS` char(1) NOT NULL DEFAULT '',
  `ORS_DESCRICAO` longtext NOT NULL,
  `ORS_QTJOGOSPAGINAS` int(11) DEFAULT NULL,
  `ORS_NROVIAS` int(11) DEFAULT NULL,
  `ORS_PESOESTIMADO` double(18,8) NOT NULL,
  `ORS_UFORCAMENTO` varchar(20) DEFAULT NULL,
  `ORS_TIPOVALORPAPEL` varchar(20) NOT NULL DEFAULT '',
  `ORS_AUTORIZACAONUMERO` varchar(40) DEFAULT NULL,
  `ORS_NUMERACAOINICIAL` varchar(30) DEFAULT NULL,
  `ORS_NUMERACAOFINAL` varchar(30) DEFAULT NULL,
  `ORS_PRODUTOSERVICO` varchar(20) NOT NULL DEFAULT '',
  `ORS_CODIGONCM` varchar(20) DEFAULT NULL,
  `ORS_VLRICMSREVENDA` double(18,8) NOT NULL,
  `ORS_PERCICMSREVENDA` double(18,8) NOT NULL,
  `ORS_CALCULAICMSREVENDA` char(1) NOT NULL DEFAULT '',
  `ORS_CANCELADA` char(1) NOT NULL DEFAULT '',
  `ORS_PRODUCAO` char(2) NOT NULL DEFAULT '',
  `ORS_CLASSIFICACAO` char(2) NOT NULL DEFAULT '',
  `ORS_SITUACAOID` int(20) DEFAULT NULL,
  `CODIGOLOTE` varchar(20) DEFAULT NULL,
  `SEQUENCIALLOTE` int(11) DEFAULT NULL,
  `QTO_ID` varchar(20) DEFAULT NULL,
  `PCPCODIGOSTATUSOP` int(11) DEFAULT NULL,
  `CODIGOPUBLICACAO` int(11) DEFAULT NULL,
  `ORS_VLRUNITPRAZOSEMIPI` double(18,8) NOT NULL,
  `ORS_VLRUNITVISTASEMIPI` double(18,8) NOT NULL,
  `ORS_VLRFINALVISTASEMIPI` double(18,8) NOT NULL,
  `ORS_VLRFINALPRAZOSEMIPI` double(18,8) NOT NULL,
  `ORS_VLRBRUTOPRAZOIPIFORA` double(18,8) NOT NULL,
  `ORS_VLRBRUTOVISTAIPIFORA` double(18,8) NOT NULL,
  `ORS_CSTICMS` varchar(20) DEFAULT NULL,
  `ORS_CSTIPI` varchar(20) DEFAULT NULL,
  `ORS_CSTPIS` varchar(20) DEFAULT NULL,
  `ORS_CSTCOFINS` varchar(20) DEFAULT NULL,
  `ORS_CNAE` varchar(10) DEFAULT NULL,
  `ORS_VLRCSLL` double(18,8) NOT NULL,
  `ORS_PERCCSLL` double(18,8) NOT NULL,
  `ORS_CALCULACSLL` varchar(1) NOT NULL DEFAULT '',
  `ORS_STATUSFATURAMENTO` varchar(20) NOT NULL DEFAULT '',
  `CODPERFILIMPOSTO` int(11) DEFAULT NULL,
  `ORS_DATAPROVAIMPRESSAO` datetime DEFAULT NULL,
  `CLI_IDFATURAR` varchar(20) NOT NULL DEFAULT '',
  `INFORMACOESNOTA` varchar(50) DEFAULT NULL,
  `OS_INFOFATURAMENTO` longtext,
  `OS_OPORIGEM` varchar(20) DEFAULT '',
  `VLR_CUSTO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor de custo realizado',
  `PER_MARGEMLUCRO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentua de margem de lucro realizada',
  `VLR_MARGEMLUCRO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da margem de lucro realizada',
  `PER_CONTRIMARGINAL_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentual de contribuição marginal realizada',
  `VLR_CONTRIMARGINAL_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da contribuição marginal realizada',
  `PER_COMISSAO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Percentual de comissão reaalizada',
  `VLR_COMISSAO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor da comissão realizada',
  `VLR_IMPOSTO_REALIZADO` double(18,8) DEFAULT '0.00000000' COMMENT 'Valor do imposto realizado',
  `VLR_TOTAL_REALIZADO` double(18,8) DEFAULT '0.00000000',
  `TIPOVLRPOSCALC` varchar(30) DEFAULT NULL,
  `ORS_DATALIBERACAOFAT` date DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `NOMECONSUMIDOR` varchar(200) DEFAULT NULL,
  `EMAILCONSUMIDOR` varchar(100) DEFAULT NULL,
  `CPFCNPJCONSUMIDOR` varchar(30) DEFAULT NULL,
  `ORS_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `ORS_ART_ID` int(11) DEFAULT NULL,
  `IDSALESFORCE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkEndereco` (`EMP_ID`,`CLI_ID`,`END_ID`),
  KEY `fkContato` (`EMP_ID`,`CLI_ID`,`CON_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLotes` (`EMP_ID`,`CODIGOLOTE`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkPCPStatusOrc` (`EMP_ID`,`ORS_ID`,`PCPCODIGOSTATUSOP`),
  KEY `fkPublicacao` (`EMP_ID`,`CODIGOPUBLICACAO`),
  KEY `fkPerfilImposto` (`EMP_ID`,`CODPERFILIMPOSTO`),
  KEY `fkClienteFat` (`EMP_ID`,`CLI_IDFATURAR`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicoagencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicoagencia` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORA_PERCCOMISSAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicoetiqueta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicoetiqueta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `OST_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOTIPOEMBALAGEM` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `NUMERACAO` varchar(100) NOT NULL DEFAULT '',
  `DESCRICAOITEM` varchar(50) NOT NULL DEFAULT '',
  `QUANTIDADEITEM` double(18,8) NOT NULL,
  `DESCRICAOTIPOEMBALAGEM` varchar(50) DEFAULT NULL,
  `QUANTIDADEPOREMB` double(18,8) NOT NULL,
  `NUMERACAOOBS` varchar(100) DEFAULT NULL,
  `QTETIQUETAS` double(18,8) NOT NULL,
  `NUMEROINICIAL` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`OST_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkTipoEmbalagem` (`EMP_ID`,`CODIGOTIPOEMBALAGEM`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicoetiquetasgeradas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicoetiquetasgeradas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `OST_ID` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IMPRIMIR` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`OST_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkEtiquetas` (`EMP_ID`,`ORS_ID`,`OST_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolam` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORL_TIPOLAMINA` varchar(20) NOT NULL DEFAULT '',
  `ORL_GRAMATURAPAPEL` double(18,8) NOT NULL,
  `ORL_QTCORFRENTE` int(11) NOT NULL DEFAULT '0',
  `ORL_QTCORVERSO` int(11) NOT NULL DEFAULT '0',
  `ORL_MEDLARGLAMINA` double(18,8) NOT NULL,
  `ORL_MEDALTURALAMINA` double(18,8) NOT NULL,
  `ORL_MEDORELHA` double(18,8) DEFAULT NULL,
  `ORL_COBRACHAPA` char(1) NOT NULL DEFAULT '',
  `ORL_COBRAACERTO` char(1) NOT NULL DEFAULT '',
  `ORL_COBRALAVACAO` char(1) NOT NULL DEFAULT '',
  `ORL_CHAPAADIC` int(11) DEFAULT NULL,
  `ORL_ACERTOADIC` int(11) DEFAULT NULL,
  `ORL_LAVACAOADIC` int(11) DEFAULT NULL,
  `ORL_MEDSANGRIA` double(18,8) NOT NULL,
  `LMQ_FORMATO` int(11) NOT NULL DEFAULT '0',
  `LMQ_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `LMQ_MEDLARGFORMATO` double(18,8) NOT NULL,
  `LMQ_MEDALTFORMATO` double(18,8) NOT NULL,
  `LMQ_TIRARETIRA` char(1) NOT NULL DEFAULT '',
  `LMQ_MAQUINAESCUSUARIO` char(1) NOT NULL DEFAULT '',
  `LMQ_PAPELESCUSUARIO` char(1) NOT NULL DEFAULT '',
  `LMQ_FORMATOMIOLOADIC` int(11) NOT NULL DEFAULT '0',
  `LMQ_MONTAGEMIOLOMADIC` int(11) NOT NULL DEFAULT '0',
  `LMQ_TIRARETIRAMIOLOADIC` char(1) NOT NULL DEFAULT '',
  `LMQ_MEDIDALOMBADA` double(18,8) NOT NULL,
  `LMQ_QTPAGINAS` int(11) NOT NULL DEFAULT '0',
  `LMQ_QTCADERNOS` double(18,8) NOT NULL,
  `LMQ_QTPAGMIOLOADIC` int(11) NOT NULL DEFAULT '0',
  `TPP_ID` int(11) NOT NULL DEFAULT '0',
  `MDP_ID` varchar(20) NOT NULL DEFAULT '',
  `LMQ_VLRUNITARIOPAPEL` double(18,8) NOT NULL,
  `LMQ_VLRUNITARIOCHAPA` double(18,8) NOT NULL,
  `LMQ_VLRHRMAQUINA` double(18,8) NOT NULL,
  `ORL_DESCRICAO` varchar(20) NOT NULL DEFAULT '',
  `ORL_COBRALAVACAOVERSO` char(1) NOT NULL DEFAULT '',
  `LMQ_CALCULAEMESCALA` char(1) NOT NULL DEFAULT '',
  `LMQ_OBSERVACOESMONTAGEM` longtext,
  `ORL_QTLAMINAS` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_MEDLARGFORMATOCORTEBOBINA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_MEDALTFORMATOCORTEBOBINA` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VERNIZEMLINHA` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkTipoPapel` (`EMP_ID`,`TPP_ID`),
  KEY `fkMedidaPapel` (`EMP_ID`,`MDP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamchapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamchapa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `CHA_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHA_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LMQ_QTMP` double(18,8) NOT NULL,
  `LMQ_VLRMP` double(18,8) NOT NULL,
  `TIPOREGISTRO` varchar(10) NOT NULL DEFAULT '',
  `LMQ_CHAPACLICK` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`CHA_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkChapa` (`EMP_ID`,`CHA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamimpressao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamimpressao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LMQ_TIRAGEMIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOIMPRESSAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOLAVAGEM` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRLAVAGEM` double(18,8) NOT NULL,
  `LMQ_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRACERTO` double(18,8) NOT NULL,
  `LMQ_OBSERVACOESMAQUINA` longtext,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamimpressaooriginal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamimpressaooriginal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `LMQ_TIRAGEMIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOIMPRESSAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRIMPRESSAO` double(18,8) NOT NULL,
  `LMQ_TEMPOLAVAGEM` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRLAVAGEM` double(18,8) NOT NULL,
  `LMQ_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `LMQ_VLRACERTO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolammaqacab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolammaqacab` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OLM_VALOR` double(18,8) NOT NULL,
  `OLM_TEMPO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_QUANTIDADE` double(18,8) NOT NULL,
  `OLM_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `OLM_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_TEMPOACABAMENTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_TEMPOEXECUCAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `OLM_OBSERVACOESACABAMENTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolammaqacabmatdiverso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolammaqacabmatdiverso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`MAQ_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamoriginal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamoriginal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORL_MEDLARGLAMINA` double(18,8) NOT NULL,
  `ORL_MEDALTURALAMINA` double(18,8) NOT NULL,
  `LMQ_FORMATO` int(11) NOT NULL DEFAULT '0',
  `LMQ_MONTAGEM` int(11) NOT NULL DEFAULT '0',
  `LMQ_MEDLARGFORMATO` double(18,8) NOT NULL,
  `LMQ_MEDALTFORMATO` double(18,8) NOT NULL,
  `LMQ_TIRARETIRA` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolampapel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolampapel` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `PPO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PPO_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `MDP_ID` varchar(20) NOT NULL DEFAULT '',
  `LMQ_QTPAPEL` double(18,8) NOT NULL,
  `LMQ_VLRPAPEL` double(18,8) NOT NULL,
  `LMQ_QTPAPELPERDA` double(18,8) NOT NULL,
  `LMQ_VLRPAPELPERDA` double(18,8) NOT NULL,
  `LMQ_QTPAPELACERTO` double(18,8) NOT NULL,
  `LMQ_VLRPAPELACERTO` double(18,8) NOT NULL,
  `TIPOREGISTRO` varchar(10) NOT NULL DEFAULT '',
  `LMQ_OBSERVACOESPAPEL` longtext,
  `LMQ_QTPACOTES` int(11) NOT NULL DEFAULT '0',
  `LMQ_QTPAPELARRED` double(18,8) NOT NULL,
  `LMQ_VLRPAPELARRED` double(18,8) NOT NULL,
  `ALTURACORTEBOB` double(18,8) DEFAULT NULL,
  `LARGURACORTEBOB` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`PPO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkPapel` (`EMP_ID`,`PPO_ID`),
  KEY `fkMedidaPapel` (`EMP_ID`,`MDP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OLS_QUANTIDADE` double(18,8) NOT NULL,
  `OLS_VLRUNITARIO` double(18,8) NOT NULL,
  `OLS_QTTOTAL` double(18,8) NOT NULL,
  `OLS_VLRTOTAL` double(18,8) NOT NULL,
  `OLS_DESCRICAO` longtext,
  `OLS_TEMPOEXEC` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`OSR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkOrcServico` (`EMP_ID`,`ORS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolamtinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolamtinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `ORL_ID` int(11) NOT NULL DEFAULT '0',
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `OST_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIN_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `OTQ_QTTINTA` double(18,8) NOT NULL,
  `OTQ_VLRTINTA` double(18,8) NOT NULL,
  `TIPOREGISTRO` varchar(10) NOT NULL DEFAULT '',
  `OTQ_TIPOTINTA` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`ORL_ID`,`TIN_ID`,`OST_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcLamina` (`EMP_ID`,`ORC_ID`,`ORL_ID`),
  KEY `fkTinta` (`EMP_ID`,`TIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolocalentrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolocalentrega` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORS_LOCALENTREGADIFDESTINO` char(1) NOT NULL,
  `ORS_CNPJCPFDESTINO` varchar(14) DEFAULT NULL,
  `ORS_LOGRADOURODESTINO` varchar(100) DEFAULT NULL,
  `ORS_NUMERODESTINO` varchar(60) DEFAULT NULL,
  `ORS_COMPLEMENTODESTINO` varchar(60) DEFAULT NULL,
  `ORS_BAIRRODESTINO` varchar(60) DEFAULT NULL,
  `ORS_CODIGOMUNICIPIODESTINO` int(11) DEFAULT NULL,
  `ORS_SIGLAUFDESTINO` char(2) DEFAULT NULL,
  `ORS_CODIGOENDDIFENTREGA` int(11) DEFAULT NULL,
  `ORS_CONTATO` varchar(100) DEFAULT NULL,
  `ORS_MODALIDADEFRETE` varchar(20) DEFAULT '',
  `ORS_CODIGOTRANSPORTADORA` varchar(20) DEFAULT '',
  `ORS_CEPDESTINO` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolog` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA` datetime DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `TEXTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicolotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicolotes` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOLOTE` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADELOTES` int(11) NOT NULL DEFAULT '0',
  `TIPOPROCESSO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOLOTE`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicomaterial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicomaterial` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `PRECOCUSTO` double(18,8) NOT NULL,
  `PRECOTOTAL` double(18,8) NOT NULL,
  `QUANTIDADETOTAL` double(18,8) NOT NULL,
  `QUANTIDADECALCULADA` double(18,8) NOT NULL,
  `CODIGOCOMPONENTE` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`MTR_ID`,`SEQUENCIAL`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicoprodutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicoprodutor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PRO_PERCCOMISSAO` double(18,8) NOT NULL,
  `PES_IDPAIAGENCIA` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkProdutor` (`EMP_ID`,`PES_ID`),
  KEY `fkAgencia` (`EMP_ID`,`PES_IDPAIAGENCIA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicoservgeral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicoservgeral` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `OSG_QUANTIDADE` double(18,8) NOT NULL,
  `OSG_VLRUNIT` double(18,8) NOT NULL,
  `OSG_VLRTOTAL` double(18,8) NOT NULL,
  `OSG_DESCRICAO` longtext,
  `OSG_TEMPOEXECUCAO` int(10) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`ORC_ID`,`OSR_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservicostatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservicostatus` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DOC_ID` int(10) unsigned DEFAULT NULL,
  `CLASSIFICACAO` int(10) unsigned DEFAULT NULL,
  `SEQUENCIALITEM` int(10) unsigned DEFAULT NULL,
  `CODIGOTIPOSTATUS` int(11) NOT NULL DEFAULT '0',
  `DATA` datetime DEFAULT NULL,
  `HORA` time DEFAULT NULL,
  `QUANTIDADE` double(18,8) NOT NULL,
  `JUSTIFICATIVA` longtext,
  `NOTASERIE` varchar(20) DEFAULT NULL,
  `NOTANUMERO` int(11) DEFAULT NULL,
  `NOTASEQUENCIALITEM` int(11) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL DEFAULT '',
  `JUSTIFICATIVACANC` longtext,
  `DATACANCELAMENTO` datetime DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `ORC_ID` varchar(30) DEFAULT NULL,
  `IDOPPRODUTO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkTipoStatusOP` (`EMP_ID`,`CODIGOTIPOSTATUS`),
  KEY `akOrdServStatus1` (`EMP_ID`,`NOTASERIE`,`NOTANUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ordemservplanejentrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordemservplanejentrega` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '',
  `PLE_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PLE_QTENTREGA` int(11) NOT NULL DEFAULT '0',
  `PLE_QTENTREGAESTOQUE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `PLE_DATAENTREGA` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ORIGEM` varchar(30) NOT NULL,
  `CODIGOITEM` varchar(30) NOT NULL,
  `SALDOPRODUZIR` double(18,8) NOT NULL,
  `SALDOPRODUZIRESTOQUE` double(18,8) NOT NULL,
  `SALDOFATURAR` double(18,8) NOT NULL,
  `FATORCONVERSAO` double(18,8) NOT NULL,
  `PLE_DESCRICAOFATITEM` varchar(1000) NOT NULL,
  `ORIGEMVALORFATURAMENTO` varchar(30) NOT NULL,
  `NUMEROORDEMCOMPRA` varchar(15) DEFAULT NULL,
  `NUMEROITEMORDEMCOMPRA` int(6) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ORS_ID`,`PLE_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pagar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagar` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPODOCUMENTO` varchar(20) NOT NULL DEFAULT '',
  `PERCCORRECAODIARIA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CHAVE`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pais` (
  `PAIS_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PAIS_CODIGO` int(11) NOT NULL,
  `PAIS_NOME` varchar(60) NOT NULL,
  PRIMARY KEY (`PAIS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `papelorc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `papelorc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PPO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PPO_DESCRICAO` varchar(200) NOT NULL DEFAULT '',
  `PPO_GRAMATURA` double(18,8) NOT NULL,
  `MDP_ID` varchar(20) DEFAULT NULL,
  `TPP_ID` int(11) NOT NULL DEFAULT '0',
  `PPO_SENTIDOFIBRA` varchar(20) NOT NULL DEFAULT '',
  `PPO_IMPUMAFACE` char(1) NOT NULL DEFAULT '',
  `PPO_FORMATOPAP` varchar(20) NOT NULL DEFAULT '',
  `PPO_FATORABSTINTA` double(18,8) NOT NULL,
  `PPO_UN` varchar(10) NOT NULL DEFAULT '',
  `PPO_VALOR` double(18,8) NOT NULL,
  `PPO_VALORSEMICMS` double(18,8) NOT NULL,
  `PPO_VALORIMUNE` double(18,8) NOT NULL,
  `PPO_SALDOINICIAL` double(18,8) DEFAULT NULL,
  `PPO_QTMINIMA` double(18,8) DEFAULT NULL,
  `PPO_DESATIVADO` char(1) NOT NULL DEFAULT '',
  `PPO_FATORCONVKG` double(18,8) DEFAULT NULL,
  `PPO_ORIGEMAQUISICAO` varchar(20) DEFAULT NULL,
  `PPO_QTFOLHASPACOTE` double(18,8) NOT NULL,
  `PPO_SALDOFISICO` double(18,8) NOT NULL,
  `PPO_SALDOEMPENHADO` double(18,8) NOT NULL,
  `PPO_DATAALTERACAOVLR` datetime DEFAULT NULL,
  `PPO_CODIGOFORNECEDOR` varchar(20) DEFAULT NULL,
  `CLASSFISCAL` varchar(10) DEFAULT NULL,
  `PPO_UNCOMPRA` varchar(10) NOT NULL DEFAULT '',
  `PPO_VALORCOMPRA` double(18,8) NOT NULL,
  `PPO_VALORCOMPRAFINAL` double(18,8) NOT NULL,
  `PERCENTUALICMS` double(18,8) NOT NULL,
  `PERCENTUALIPI` double(18,8) NOT NULL,
  `PPO_DATAALTERACAOVLRCOMPRA` datetime DEFAULT NULL,
  `PERCENTUALPERDA` double(18,8) NOT NULL,
  `LARGURA` double(18,8) NOT NULL,
  `CODIGOREFERENCIA` varchar(35) DEFAULT NULL,
  `PPO_SALDOEMPENHADOOP` double(18,8) DEFAULT NULL,
  `PPO_PRECOMEDIO` double(18,5) DEFAULT '0.00000',
  `PPO_CSTICMS` varchar(3) DEFAULT NULL,
  `PPO_CSTIPI` varchar(3) DEFAULT NULL,
  `PPO_CSTPIS` varchar(3) DEFAULT NULL,
  `PPO_CSTCOFINS` varchar(3) DEFAULT NULL,
  `PPO_CNAE` varchar(10) DEFAULT NULL,
  `PPO_TIPOCERTIFICACAO` varchar(20) NOT NULL,
  `PPO_TIPOITEM` char(2) DEFAULT NULL,
  `PPO_ESPECIFICACAO` longtext,
  `PPO_SALDOEMPENHADOVENDA` double(18,8) NOT NULL,
  `PPO_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `PPO_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `PPO_UNIDADELARGURA` varchar(30) DEFAULT NULL,
  `PPO_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `PPO_PERMITIRMEDIMPMAIORMEDFOLHA` char(1) NOT NULL,
  `PPO_PERCCOBRARFOLHAINTEIRA` double(18,8) NOT NULL,
  `PPO_TIPOCALCPERDA` varchar(30) DEFAULT NULL,
  `INFORMARVALORMEDIOMANUAL` char(1) DEFAULT 'N',
  `PPO_CODPLANOCONTA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PPO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMedidaPapel` (`EMP_ID`,`MDP_ID`),
  KEY `fkTipoPapel` (`EMP_ID`,`TPP_ID`),
  KEY `fkFornecedor` (`EMP_ID`,`PPO_CODIGOFORNECEDOR`),
  KEY `fkPlanoConta` (`EMP_ID`,`PPO_CODPLANOCONTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pariepgramatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pariepgramatura` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PEG_FAIXAUM_PRIMEIRA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXAUM_ULTIMA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXADOIS_PRIMEIRA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXADOIS_ULTIMA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXATRES_PRIMEIRA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXATRES_ULTIMA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXAQUATRO_PRIMEIRA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXAQUATRO_ULTIMA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXACINCO_PRIMEIRA` int(11) NOT NULL DEFAULT '0',
  `PEG_FAIXACINCO_ULTIMA` int(11) NOT NULL DEFAULT '0',
  `PEG_PERCNOVAENTRADA` double(18,8) NOT NULL,
  `PEG_PERCACIMATETO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `parieptiragem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parieptiragem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PET_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PET_TIRAGEM` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`PET_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patrimonio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patrimonio` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `PTR_ORIGEMITEM` varchar(20) NOT NULL,
  `PTR_CODIGOITEM` varchar(20) NOT NULL,
  `PTR_ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PTR_NUMEROSERIE` varchar(50) NOT NULL,
  `PTR_NUMEROPATRIMONIO` varchar(50) NOT NULL,
  `PTR_STATUS` varchar(20) NOT NULL,
  `CODIGOFORNECEDOR` varchar(20) DEFAULT NULL,
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PTR_ORIGEMITEM`,`PTR_CODIGOITEM`,`PTR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `patrimoniomovimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patrimoniomovimentacao` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `ID_PTRMOVIMENTACAO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PTR_ID` int(11) NOT NULL,
  `PTR_ORIGEMITEM` varchar(20) NOT NULL,
  `PTR_CODIGOITEM` varchar(20) NOT NULL,
  `TIPOOPERACAO` char(1) NOT NULL,
  `DATAMOVIMENTACAO` datetime NOT NULL,
  `DATARETORNO` datetime NOT NULL,
  `NUMERONF` int(11) DEFAULT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `DOC_ID` int(11) DEFAULT NULL,
  `CLASSIFICACAO` int(11) DEFAULT NULL,
  `SEQUENCIALITEM` int(11) DEFAULT NULL,
  `CODIGOCLIENTE` varchar(20) DEFAULT NULL,
  `CFOP` varchar(20) DEFAULT NULL,
  `CANCELADA` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_PTRMOVIMENTACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akPatrimonioMovimentacao1` (`EMP_ID`,`PTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpapontamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpapontamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOPROCESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIRAGEMAPONTADA` double(18,8) DEFAULT NULL,
  `QTFOLHASPEDACOS` double(18,8) DEFAULT NULL,
  `QTFOLHASAPONTADA` double(18,8) DEFAULT NULL,
  `QTFINALAPONTADA` double(18,8) DEFAULT NULL,
  `CODIGOOCORRENCIA` int(11) DEFAULT NULL,
  `CODIGOOPERADOR` int(11) DEFAULT NULL,
  `DATAHORAINICIAL` datetime DEFAULT NULL,
  `DATAHORAFINAL` datetime DEFAULT NULL,
  `TEMPOTOTAL` int(11) DEFAULT NULL,
  `TIPOAPONTAMENTO` char(1) NOT NULL DEFAULT '',
  `CODIGOTIPOTEMPO` int(11) NOT NULL DEFAULT '0',
  `QTMETROLINEAR` double(18,8) DEFAULT NULL,
  `QTDUNIDADEPRODUTIVA` int(11) NOT NULL DEFAULT '0',
  `OBSERVACAO` longtext,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOPROCESSO`,`CODIGOTRABALHO`),
  KEY `akPCPApontamento1` (`EMP_ID`,`CODIGOPROCESSO`,`CODIGOTRABALHO`,`CODIGOOPERADOR`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPProcessos` (`EMP_ID`,`CODIGOPROCESSO`,`CODIGOTRABALHO`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`),
  KEY `fkOcorrencia` (`EMP_ID`,`CODIGOOCORRENCIA`),
  KEY `fkOperador` (`EMP_ID`,`CODIGOOPERADOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpapontamentooperador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpapontamentooperador` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOPROCESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `CODIGOOPERADOR` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOPROCESSO`,`CODIGOTRABALHO`,`CODIGOOPERADOR`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPProcessos` (`EMP_ID`,`CODIGOPROCESSO`,`CODIGOTRABALHO`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGO`),
  KEY `fkOperador` (`EMP_ID`,`CODIGOOPERADOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpapuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpapuracao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'Empresa',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '0' COMMENT 'Ordem de produção',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAEMISSAO` datetime DEFAULT NULL COMMENT 'Emissão da OP',
  `QUANTIDADEOP` int(11) DEFAULT NULL COMMENT 'Quantidade da OP',
  `CODIGOTRABALHO` int(11) DEFAULT NULL COMMENT 'Código trabalho PCP',
  `DATAULTIMAAPURACAO` datetime DEFAULT NULL COMMENT 'Data da última apuração',
  `CODIGOUSUARIO` int(11) DEFAULT NULL COMMENT 'Código usuário ultima apuração',
  `DATAULTIMOAPONTAMENTO` datetime DEFAULT NULL COMMENT 'Data do último apontamento',
  `REAPURAR` char(1) DEFAULT NULL COMMENT 'Necessário reapurar',
  `TIPOPROCESSO` varchar(50) DEFAULT '' COMMENT 'Tipo do processo',
  `POSCALCULOEFETUADO` char(1) DEFAULT '' COMMENT 'Pós-Cálculo efetuado',
  PRIMARY KEY (`EMP_ID`,`ORS_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpapuracaoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpapuracaoitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'Empresa',
  `ORS_ID` varchar(20) NOT NULL DEFAULT '' COMMENT 'Ordem de produção',
  `TIPO` varchar(20) NOT NULL DEFAULT '' COMMENT 'Tipo do registro',
  `SEQUENCIAL` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Sequencial',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `COD_ITEM` varchar(20) DEFAULT NULL COMMENT 'Código do item de acordo com o tipo',
  `DESCRICAO` varchar(100) DEFAULT NULL COMMENT 'Descrição material/serviço',
  `MATER_ORIGEM` char(1) DEFAULT NULL COMMENT 'Origem do material',
  `COD_ITEMPREVISTO` varchar(20) DEFAULT NULL COMMENT 'Código do item previsto',
  `DESCRICAOPREVISTO` varchar(100) DEFAULT NULL COMMENT 'Descrição do item previsto',
  `COD_EQUIP` int(11) DEFAULT NULL COMMENT 'Código Equipamento',
  `PROCESSO` int(11) DEFAULT NULL COMMENT 'Código Processo',
  `CODIGOCOMPONENTE` int(11) DEFAULT NULL COMMENT 'Código do componente',
  `TIPOCOMPONENTE` varchar(20) DEFAULT NULL COMMENT 'Tipo Componente',
  `DESCCOMPONENTE` varchar(30) DEFAULT NULL COMMENT 'Descrição Componente',
  `PREV_PREPARACAO` double(18,8) DEFAULT NULL COMMENT 'Tempo previsto preparação',
  `PREV_PRODUTIVO` double(18,8) DEFAULT NULL COMMENT 'Tempo previsto produtivo',
  `REAL_PREPARACAO` double(18,8) DEFAULT NULL COMMENT 'Tempo realizado preparação',
  `REAL_PRODUTIVO` double(18,8) DEFAULT NULL COMMENT 'Tempo realizado produtivo',
  `REAL_INTERVALO` double(18,8) DEFAULT NULL COMMENT 'Tempo realizado intervalo',
  `REAL_IMPRODOP` double(18,8) DEFAULT NULL COMMENT 'Tempo realizado improdutivo OP',
  `REAL_IMPRODEMP` double(18,8) DEFAULT NULL COMMENT 'Tempo realizado improdutivo empresa',
  `QTD_ORCADO` double(18,8) DEFAULT NULL COMMENT 'Quantidade orçada',
  `VLR_ORCADO` double(18,8) DEFAULT NULL COMMENT 'Valor orçado',
  `QTD_REALIZADO` double(18,8) DEFAULT NULL COMMENT 'Quantidade realizada',
  `VLR_REALIZADO` double(18,8) DEFAULT NULL COMMENT 'Valor realizada',
  PRIMARY KEY (`SEQUENCIAL`,`EMP_ID`,`ORS_ID`,`TIPO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`ORS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpexpedicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpexpedicao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA` datetime DEFAULT NULL,
  `CODIGOOP` varchar(20) NOT NULL DEFAULT '',
  `QUANTIDADEPRODUZIDA` double(18,8) NOT NULL,
  `STATUS` char(1) NOT NULL DEFAULT '',
  `SALDO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LOTE`,`CODIGOTRABALHO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`CODIGOOP`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcppausaprogramada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcppausaprogramada` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PAUSA_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MOTIVO` varchar(80) NOT NULL DEFAULT '',
  `TIPOPAUSA` varchar(30) NOT NULL DEFAULT '',
  `DATAHORAINICIAL` datetime NOT NULL,
  `DATAHORAFINAL` datetime NOT NULL,
  `DIA` date DEFAULT NULL,
  `CODIGOTURNO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PAUSA_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcppausaprogramadaequipamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcppausaprogramadaequipamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PAUSA_ID` int(11) NOT NULL DEFAULT '0',
  `EQUIP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PAUSA_ID`,`EQUIP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkEquipamento` (`EMP_ID`,`EQUIP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpprocessoatividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpprocessoatividades` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOPCPPROCESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ATIVIDADE` char(1) NOT NULL DEFAULT '',
  `DATAINICIO` datetime DEFAULT NULL,
  `HORAINICIO` time DEFAULT NULL,
  `DATAFIM` datetime DEFAULT NULL,
  `HORAFIM` time DEFAULT NULL,
  `DURACAO` int(11) DEFAULT NULL,
  `TEMPOTRABALHO` int(11) DEFAULT NULL,
  `CODIGOTIPOTEMPO` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOPCPPROCESSO`,`CODIGOTRABALHO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPProcessos` (`EMP_ID`,`CODIGOPCPPROCESSO`,`CODIGOTRABALHO`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpprocessoentrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpprocessoentrega` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOLOTE` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `CODIGOPROCESSO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QUANTIDADEPRODUZIDAPARCIAL` double(18,8) NOT NULL,
  `SALDO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOLOTE`,`CODIGOTRABALHO`,`CODIGOPROCESSO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`),
  KEY `fkPCPProcessos` (`EMP_ID`,`CODIGOPROCESSO`,`CODIGOTRABALHO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpprocessos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpprocessos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `NIVEL` int(11) NOT NULL DEFAULT '0',
  `CODIGOEQUIPAMENTO` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOEQUIPAMENTO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOOP` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOOP` longtext,
  `QUANTIDADE` double(18,8) NOT NULL,
  `TIRAGEM` double(18,8) NOT NULL,
  `CODIGOCOMPONENTE` int(11) NOT NULL DEFAULT '0',
  `TIPOCOMPONENTE` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOCOMPONENTE` varchar(20) NOT NULL DEFAULT '',
  `DURACAO` int(11) NOT NULL DEFAULT '0',
  `DATAINICIO` datetime DEFAULT NULL,
  `HORAINICIO` time DEFAULT NULL,
  `DATAFIM` datetime DEFAULT NULL,
  `HORAFIM` time DEFAULT NULL,
  `CODIGOTAREFA` int(11) NOT NULL DEFAULT '0',
  `DESCRICAOTAREFA` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCLIENTE` varchar(20) NOT NULL DEFAULT '',
  `NOMECLIENTE` varchar(100) NOT NULL DEFAULT '',
  `NOMEFANTASIACLIENTE` varchar(30) NOT NULL DEFAULT '',
  `CODIGOMAQUINA` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOMAQUINA` varchar(50) NOT NULL DEFAULT '',
  `FORMAACABAMENTO` varchar(20) DEFAULT NULL,
  `CODIGOSERVICO` varchar(20) DEFAULT NULL,
  `DESCRICAOSERVICO` varchar(50) DEFAULT NULL,
  `STATUS` char(1) DEFAULT NULL,
  `CODIGOPROCESSODEPENDENTE` int(11) DEFAULT NULL,
  `CODIGOTRABALHODEPENDENTE` int(11) DEFAULT NULL,
  `CHAVEUNICA` int(11) NOT NULL DEFAULT '0',
  `TIRAGEMAPONTADA` double(18,8) DEFAULT NULL,
  `QTFOLHASPEDACOS` double(18,8) DEFAULT NULL,
  `QTFOLHASAPONTADA` double(18,8) DEFAULT NULL,
  `QTFINALAPONTADA` double(18,8) DEFAULT NULL,
  `QTPRODUZIDAPARCIAL` double(18,8) DEFAULT NULL,
  `MONTAGEM` int(11) DEFAULT NULL,
  `TIPOMAQUINA` varchar(20) DEFAULT NULL,
  `NUMEROCADERNO` int(11) DEFAULT NULL,
  `COROCORRENCIA` int(11) DEFAULT NULL,
  `OBSERVACOES` longtext,
  `PREPRODUCAO` char(1) NOT NULL DEFAULT 'N',
  `QTMETROSLINEAR` double(18,8) DEFAULT NULL,
  `SEQUENCIAEXECUCAO` int(11) NOT NULL DEFAULT '0',
  `DISPONIVEL` char(1) NOT NULL DEFAULT '',
  `AGRUPADO` char(1) NOT NULL,
  `CODIGOTRABALHOVINCULADO` int(11) DEFAULT NULL,
  `CODIGOPROCESSOVINCULADO` int(11) DEFAULT NULL,
  `DATAENTREGATRABALHOAGRUPADO` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOTRABALHO`),
  KEY `akPCPProcessos1` (`CODIGO`,`CODIGOTRABALHO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`),
  KEY `fkEquipamento` (`EMP_ID`,`CODIGOEQUIPAMENTO`),
  KEY `fkOrdemProducao` (`EMP_ID`,`CODIGOOP`),
  KEY `fkTarefa` (`EMP_ID`,`CODIGOTAREFA`),
  KEY `fkCliente` (`EMP_ID`,`CODIGOCLIENTE`),
  KEY `fkMaquina` (`EMP_ID`,`CODIGOMAQUINA`),
  KEY `akPCPProcessos2` (`EMP_ID`,`CODIGOPROCESSODEPENDENTE`,`CODIGOTRABALHODEPENDENTE`),
  KEY `akPCPProcessos3` (`EMP_ID`,`CODIGOEQUIPAMENTO`,`STATUS`,`DISPONIVEL`),
  KEY `akPCPProcesso4` (`EMP_ID`,`CODIGOTRABALHOVINCULADO`,`CODIGOPROCESSOVINCULADO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpstatusop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpstatusop` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(60) NOT NULL DEFAULT '',
  `ESPECIAL` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcpstatusporop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcpstatusporop` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOOP` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOSTATUSOP` int(11) NOT NULL DEFAULT '0',
  `DATAHORA` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOOP`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`CODIGOOP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcptempos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcptempos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOPROCESSO` int(11) NOT NULL DEFAULT '0',
  `CODIGOTRABALHO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAINICIO` datetime DEFAULT NULL,
  `HORAINICIO` time DEFAULT NULL,
  `DATAFIM` datetime DEFAULT NULL,
  `HORAFIM` time DEFAULT NULL,
  `DURACAO` int(11) NOT NULL DEFAULT '0',
  `TIPO` char(1) NOT NULL DEFAULT '',
  `ATIVIDADE` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOPROCESSO`,`CODIGOTRABALHO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPCPTrabalhos` (`EMP_ID`,`CODIGOTRABALHO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pcptrabalhos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcptrabalhos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `CODIGOOP` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPOPROCESSO` varchar(20) NOT NULL DEFAULT '',
  `DATAPROGRAMACAO` datetime DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `NOMEUSUARIO` varchar(80) NOT NULL DEFAULT '',
  `STATUS` char(1) DEFAULT NULL,
  `OBSERVACAOPOSCALCULO` longtext,
  `MODOAPONTAMENTO` char(1) DEFAULT NULL,
  `JUSTIFICATIVA` longtext,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`CODIGOOP`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrdemProducao` (`EMP_ID`,`CODIGOOP`),
  KEY `fkUsuario` (`CODIGOUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilcobranca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilcobranca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilpreenchimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilpreenchimento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PER_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `PER_TIPO` varchar(30) NOT NULL DEFAULT '',
  `PER_PADRAO` char(1) NOT NULL,
  `PER_DESATIVADO` int(11) NOT NULL DEFAULT '0' COMMENT '0 = Nao, 1 = Sim',
  PRIMARY KEY (`EMP_ID`,`PER_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilpreenchimentoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilpreenchimentoitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PER_ID` int(11) NOT NULL DEFAULT '0',
  `PER_SEQ` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PER_TABELA` varchar(50) NOT NULL DEFAULT '',
  `PER_CAMPO` varchar(50) NOT NULL DEFAULT '',
  `PER_VALOR` varchar(200) DEFAULT '',
  `PER_TIPOCAMPO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`PER_ID`,`PER_SEQ`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPerfilPreenc` (`EMP_ID`,`PER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilsatisfacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilsatisfacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEPERFIL` varchar(100) NOT NULL DEFAULT '',
  `ASSUNTO` varchar(100) NOT NULL DEFAULT '',
  `CORPOEMAIL` longtext,
  `PADRAO` char(1) NOT NULL,
  `CODIGOCATEGORIA` int(11) DEFAULT NULL,
  `ORIGEM` varchar(30) NOT NULL,
  `TEMPODISPARO` int(11) NOT NULL,
  `ENVIOAUTOMATICO` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCategoria` (`EMP_ID`,`CODIGOCATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilsatisfacaocomandos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilsatisfacaocomandos` (
  `IDCOMANDO` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `IDPESQSATISFACAO` int(11) NOT NULL DEFAULT '0',
  `STATUS` varchar(30) NOT NULL,
  `DATAPROCESSAMENTO` datetime DEFAULT NULL,
  `ERRO` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`IDCOMANDO`),
  KEY `fkPesqSatisfacao` (`IDPESQSATISFACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilsatisfacaoperguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilsatisfacaoperguntas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `IDPERGUNTA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERGUNTA` varchar(150) NOT NULL DEFAULT '',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `ORDEM` int(11) NOT NULL DEFAULT '0',
  `OBRIGATORIO` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`IDPERGUNTA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPerfilSatisfacao` (`EMP_ID`,`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `perfilsatisfacaorespostas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilsatisfacaorespostas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `IDPERGUNTA` int(11) NOT NULL DEFAULT '0',
  `IDRESPOSTA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `RESPOSTA` varchar(150) DEFAULT '',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `ORDEM` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`IDPERGUNTA`,`IDRESPOSTA`),
  KEY `fkPerfilSatisfacao` (`EMP_ID`,`CODIGO`),
  KEY `fkPerfilSatisfacaoPerguntas` (`EMP_ID`,`CODIGO`,`IDPERGUNTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `periodicidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `periodicidade` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGO_DIF` int(11) DEFAULT NULL,
  `DESCRICAO` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  UNIQUE KEY `CODIGO_DIF` (`CODIGO_DIF`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pessoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PES_TIPOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `PES_NOME_RAZAO` varchar(100) NOT NULL DEFAULT '',
  `PES_NOMEFANTASIA` varchar(200) NOT NULL DEFAULT '',
  `PES_INSCRESTADUAL` varchar(20) DEFAULT NULL,
  `PES_RG` varchar(20) DEFAULT NULL,
  `PES_CNPJ` varchar(14) DEFAULT NULL,
  `PES_CNPF` varchar(14) DEFAULT NULL,
  `PES_INSCRMUNICIPAL` varchar(20) DEFAULT NULL,
  `PES_SUFRAMA` varchar(20) DEFAULT NULL,
  `PES_OBSERVACOES` longtext,
  `PES_FLAGCLIENTE` char(1) NOT NULL DEFAULT '',
  `PES_FLAGFORNECEDOR` char(1) NOT NULL DEFAULT '',
  `PES_FLAGVENDEDOR` char(1) NOT NULL DEFAULT '',
  `PES_FLAGTRANSPORTADORA` char(1) NOT NULL DEFAULT '',
  `PES_DTCADASTRO` datetime DEFAULT NULL,
  `PES_PESSOAPAIID` varchar(20) DEFAULT NULL,
  `PES_FLAGBANCA` char(1) NOT NULL DEFAULT '',
  `PES_FLAGRESPONSAVEL` char(1) NOT NULL DEFAULT '',
  `PES_FLAGMOTOBOY` char(1) NOT NULL DEFAULT '',
  `PES_FLAGCONDUTOR` char(1) NOT NULL DEFAULT '',
  `PES_CODIGORESPONSAVEL` varchar(20) DEFAULT NULL,
  `PES_DESATIVADA` char(1) NOT NULL DEFAULT '',
  `PES_SEXO` varchar(20) DEFAULT '',
  `CLA_ID` int(11) DEFAULT NULL,
  `PES_EMAILPADRAOENVIODANFE` varchar(300) DEFAULT NULL,
  `PES_TIPOCONTRIBUINTE` varchar(20) DEFAULT NULL,
  `PES_LGPDCONSENTIMENTO` int(1) DEFAULT '0',
  `PES_LGPDPROTOCOLO` varchar(50) DEFAULT NULL,
  `PES_LGPDORIGEMDOSDADOS` int(1) DEFAULT '0',
  `PES_LGPDTITULARINATIVO` int(1) DEFAULT '0',
  `PES_INFOSENSIVEL` char(1) DEFAULT 'N',
  PRIMARY KEY (`EMP_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoaPai` (`EMP_ID`,`PES_PESSOAPAIID`),
  KEY `fkResponsavel` (`EMP_ID`,`PES_CODIGORESPONSAVEL`),
  KEY `akPessoaCPF` (`PES_CNPF`),
  KEY `akPessoaCNPJ` (`PES_CNPJ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `planejamentomensal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planejamentomensal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `MESCOMPETENCIA` int(11) NOT NULL DEFAULT '0',
  `ANOCOMPETENCIA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SALARIOS` double(18,8) NOT NULL,
  `ENCARGOS` double(18,8) NOT NULL,
  `DEPRECIACAO` double(18,8) NOT NULL,
  `DESPESAS` double(18,8) NOT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `CONTRIBUICAOMARGINAL` double(18,8) NOT NULL,
  `PONTOEQUILIBRIO` double(18,8) NOT NULL,
  `VALORVENDAS` double(18,8) NOT NULL,
  `VALORFATURAMENTO` double(18,8) NOT NULL,
  `DIASUTEIS` int(11) NOT NULL DEFAULT '0',
  `VALORVENDAMEDIADIA` double(18,8) NOT NULL,
  `VALORFATURMEDIODIA` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`MESCOMPETENCIA`,`ANOCOMPETENCIA`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `planoconta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planoconta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOCONTABIL` varchar(20) NOT NULL DEFAULT '',
  `GRUPOCONTA` varchar(20) NOT NULL DEFAULT '',
  `CODIGOPAI` int(11) NOT NULL DEFAULT '0',
  `CONTAREDUTORA` char(1) NOT NULL DEFAULT '',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `DESATIVADA` char(1) NOT NULL DEFAULT '',
  `DESPESAOPERACIONALDRE` char(1) NOT NULL DEFAULT '',
  `FORMARATEIO` varchar(30) NOT NULL,
  `RKW` char(1) DEFAULT NULL,
  `CODIGOEXTERNO` varchar(50) DEFAULT NULL,
  `DATA_ALTERACAOPLANO` date DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOREDUZIDO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkGrupoConta` (`EMP_ID`,`GRUPOCONTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `processoimpresso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `processoimpresso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `PRI_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PRI_TIPOPROCESSO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`PRI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `PRD_CST` char(3) DEFAULT NULL,
  `PRD_CLASSFISCAL` char(3) DEFAULT NULL,
  `PRD_PERCIPI` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `proposta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proposta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PROP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOP_ID` varchar(20) NOT NULL DEFAULT '',
  `PROP_DTPROPOSTA` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CLI_ID` varchar(20) NOT NULL DEFAULT '',
  `CLI_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CLI_CIDADE` varchar(50) NOT NULL DEFAULT '',
  `CLI_FONE` varchar(12) NOT NULL DEFAULT '',
  `CLI_RESPONSAVEL` varchar(50) NOT NULL DEFAULT '',
  `CLI_UF` char(2) NOT NULL DEFAULT '',
  `VEN_ID` varchar(20) NOT NULL DEFAULT '',
  `PROP_OBSERVACAO` longtext,
  `PROP_VALIDADEDIAS` int(11) NOT NULL DEFAULT '0',
  `EMAIL_DESTINO` varchar(100) NOT NULL DEFAULT '',
  `CLI_FAX` varchar(12) NOT NULL DEFAULT '',
  `PROP_QTDIASPRAZOENT` int(11) NOT NULL DEFAULT '0',
  `CLI_ENDID` int(11) DEFAULT NULL,
  `CLI_BAIRRO` varchar(20) DEFAULT NULL,
  `CLI_CEP` varchar(8) DEFAULT NULL,
  `CLI_CXPOSTAL` varchar(10) DEFAULT NULL,
  `CLI_TIPOENDERECO` varchar(20) DEFAULT NULL,
  `CLI_LOGRADOURO` varchar(100) DEFAULT NULL,
  `STP_ID` varchar(20) DEFAULT NULL,
  `PROP_PERCNEG` double(18,8) DEFAULT NULL,
  `CLIENTEAGENCIA` varchar(150) DEFAULT NULL,
  `PROP_DATASTATUS` datetime DEFAULT NULL,
  `PROP_USERSTATUS` varchar(20) DEFAULT NULL,
  `IDOPORTUNIDADESF` varchar(50) DEFAULT NULL,
  `IDCOTACAOSALESFORCE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PROP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `fkVendedor` (`EMP_ID`,`VEN_ID`),
  KEY `fkEndereco` (`EMP_ID`,`CLI_ID`,`CLI_ENDID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostafat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostafat` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `NUMERO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOCLIENTE` varchar(20) NOT NULL DEFAULT '',
  `NOMECLIENTE` varchar(100) NOT NULL DEFAULT '',
  `CODIGOCONTATOCLIENTE` int(11) DEFAULT NULL,
  `NOMECONTATOCLIENTE` varchar(50) DEFAULT NULL,
  `CODIGOVENDEDOR` varchar(20) NOT NULL DEFAULT '',
  `NOMEVENDEDOR` varchar(50) NOT NULL DEFAULT '',
  `PERCCOMISSVENDEDOR` double(18,8) NOT NULL,
  `CODIGOFORMAPAGAMENTO` varchar(20) DEFAULT NULL,
  `DESCRICAOFORMAPAGAMENTO` varchar(50) DEFAULT NULL,
  `PERCFORMAPAGTO` double(18,8) NOT NULL,
  `PERCEMBALAGEM` double(18,8) DEFAULT NULL,
  `TIPOFRETE` varchar(20) NOT NULL DEFAULT '',
  `DATAOPERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DIASVALIDADE` int(11) NOT NULL DEFAULT '0',
  `DATAVALIDADE` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `REMETENTE` varchar(20) NOT NULL DEFAULT '',
  `OBSERVACOES` longtext,
  `FRASE` longtext,
  `IMPRIMIRVALORTOTAL` char(1) NOT NULL DEFAULT '',
  `PERCDESCONTO` double(18,8) DEFAULT NULL,
  `PERCACRESCIMO` double(18,8) DEFAULT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `ORDEMCOMPRA` varchar(30) DEFAULT NULL,
  `NUMEROCONTROLE` varchar(15) DEFAULT NULL,
  `CODIGOTRANSPORTADORA` varchar(20) DEFAULT NULL,
  `NOMETRANSPORTADORA` varchar(50) DEFAULT NULL,
  `STP_ID` varchar(20) DEFAULT NULL,
  `VALORFRETE` double(18,8) NOT NULL,
  `PESOLIQUIDO` double(18,8) NOT NULL,
  `PROP_DATASTATUS` datetime DEFAULT NULL,
  `PROP_USERSTATUS` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMERO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CODIGOCLIENTE`),
  KEY `fkContato` (`EMP_ID`,`CODIGOCLIENTE`,`CODIGOCONTATOCLIENTE`),
  KEY `fkVendedor` (`EMP_ID`,`CODIGOVENDEDOR`),
  KEY `fkFormaPagto` (`EMP_ID`,`CODIGOFORMAPAGAMENTO`),
  KEY `fkTransport` (`EMP_ID`,`CODIGOTRANSPORTADORA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostafatdispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostafatdispositivolegal` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `NUMERO` varchar(20) NOT NULL DEFAULT '',
  `CODDISPLEGAL` varchar(30) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCDISPLEGAL` varchar(250) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMERO`,`CODDISPLEGAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDispLegal` (`EMP_ID`,`CODDISPLEGAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostafatitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostafatitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `NUMEROPROPOSTA` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMMATERIAL` char(1) NOT NULL DEFAULT '',
  `CODIGOMATERIAL` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOMATERIAL` varchar(600) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) DEFAULT NULL,
  `VALORUNITARIO` double(18,8) NOT NULL,
  `VALORUNITARIOBASE` double(18,8) NOT NULL,
  `VALORTOTALIMPOSTOPERFIL` double(18,8) DEFAULT NULL,
  `VALORTOTAL` double(18,8) NOT NULL,
  `DATAENTREGA` datetime DEFAULT NULL,
  `PERCDESCONTO` double(18,8) DEFAULT NULL,
  `PERCACRESCIMO` double(18,8) DEFAULT NULL,
  `CURSOX` double(18,8) DEFAULT NULL,
  `CODIGOPERFILCLASSIFICACAO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMEROPROPOSTA`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPropostaFat` (`EMP_ID`,`NUMEROPROPOSTA`),
  KEY `fkMaterial` (`EMP_ID`,`CODIGOMATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostafatpagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostafatpagamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `NUMEROPROPOSTA` varchar(20) NOT NULL DEFAULT '',
  `PARCELA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAVENCIMENTO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `VALOR` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMEROPROPOSTA`,`PARCELA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPropostaFat` (`EMP_ID`,`NUMEROPROPOSTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostaorc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostaorc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PROP_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORC_ID` varchar(20) DEFAULT NULL,
  `ORC_DESCRICAO` longtext NOT NULL,
  `ORC_PRODUTOSERVICO` varchar(20) NOT NULL DEFAULT '',
  `GRO_ID` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(30) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`PROP_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkProposta` (`EMP_ID`,`PROP_ID`),
  KEY `fkGrupoorcamento` (`EMP_ID`,`GRO_ID`),
  KEY `ak_propsotaorc_ORCID` (`ORC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `propostaorcqt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propostaorcqt` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PROP_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_VLRFINALVISTA` double(18,8) NOT NULL,
  `QTO_VLRFINALPRAZO` double(18,8) NOT NULL,
  `QTO_QUANTIDADE` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QTO_VLRUNITPRAZO` double(18,8) NOT NULL,
  `QTO_VLRUNITVISTA` double(18,8) NOT NULL,
  `GRO_ID` varchar(20) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`PROP_ID`,`SEQUENCIAL`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkProposta` (`EMP_ID`,`PROP_ID`),
  KEY `fkGrupoorcamento` (`EMP_ID`,`GRO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `publicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TITULO` varchar(200) NOT NULL DEFAULT '',
  `TIPO` varchar(20) DEFAULT NULL,
  `NUMEROREGISTRO` varchar(20) DEFAULT '',
  `CODIGOPERIODICIDADE` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPeriodicidade` (`EMP_ID`,`CODIGOPERIODICIDADE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qtorcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qtorcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ORC_ID` varchar(20) NOT NULL DEFAULT '',
  `QTO_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `QTO_QUANTIDADE` int(11) NOT NULL DEFAULT '0',
  `QTO_QTPAPEL` double(18,8) NOT NULL,
  `QTO_VLRPAPEL` double(18,8) NOT NULL,
  `QTO_QTPAPELPERDA` double(18,8) NOT NULL,
  `QTO_VLRPAPELPERDA` double(18,8) NOT NULL,
  `QTO_QTPAPELACERTO` double(18,8) NOT NULL,
  `QTO_VLRPAPELACERTO` double(18,8) NOT NULL,
  `QTO_TEMPOIMPRESSAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QTO_TIRAGEMIMPRESSAO` double(18,8) NOT NULL,
  `QTO_VLRHORAIMPRESSAO` double(18,8) NOT NULL,
  `QTO_TEMPOLAVACAO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QTO_VLRLAVACAO` double(18,8) NOT NULL,
  `QTO_TEMPOACERTO` double(18,8) NOT NULL DEFAULT '0.00000000',
  `QTO_VLRACERTO` double(18,8) NOT NULL,
  `QTO_QTCHAPAS` int(11) NOT NULL DEFAULT '0',
  `QTO_VLRCHAPAS` double(18,8) NOT NULL,
  `QTO_QTTINTA` double(18,8) NOT NULL,
  `QTO_VLRTINTA` double(18,8) NOT NULL,
  `QTO_QTSERVICO` double(18,8) NOT NULL,
  `QTO_VLRSERVICO` double(18,8) NOT NULL,
  `QTO_VLRACABAMENTO` double(18,8) NOT NULL,
  `QTO_VLRCUSTO` double(18,8) NOT NULL,
  `QTO_VLRIMPOSTOS` double(18,8) NOT NULL,
  `QTO_PERCCOMVENDEDOR` double(18,8) NOT NULL,
  `QTO_VLRCOMVENDEDOR` double(18,8) NOT NULL,
  `QTO_PERCCOMAGENCIA` double(18,8) NOT NULL,
  `QTO_VLRCOMAGENCIA` double(18,8) NOT NULL,
  `QTO_PERCMARGEMLUCRO` double(18,8) NOT NULL,
  `QTO_VLRMARGEMLUCRO` double(18,8) NOT NULL,
  `QTO_VLRCONTRIBMARGINAL` double(18,8) NOT NULL,
  `QTO_PERCFORMAPAG` double(18,8) NOT NULL,
  `QTO_VLRFORMAPAG` double(18,8) NOT NULL,
  `QTO_VLRFINALVISTA` double(18,8) NOT NULL,
  `QTO_VLRFINALPRAZO` double(18,8) NOT NULL,
  `QTO_VLRBRUTOVISTA` double(18,8) NOT NULL,
  `QTO_VLRBRUTOPRAZO` double(18,8) NOT NULL,
  `QTO_VLRPIS` double(18,8) NOT NULL,
  `QTO_VLRISS` double(18,8) NOT NULL,
  `QTO_VLROUTROS` double(18,8) NOT NULL,
  `QTO_VLRCOFINS` double(18,8) NOT NULL,
  `QTO_VLRTAXAADM` double(18,8) NOT NULL,
  `QTO_VLRIMPOSTORENDA` double(18,8) NOT NULL,
  `QTO_VLRCSLL` double(18,8) NOT NULL,
  `QTO_VLRSIMPLESFEDERAL` double(18,8) NOT NULL,
  `QTO_VLRICMS` double(18,8) NOT NULL,
  `QTO_VLRIPI` double(18,8) NOT NULL,
  `QTO_VLRUNITPRAZO` double(18,8) NOT NULL,
  `QTO_VLRUNITVISTA` double(18,8) NOT NULL,
  `QTO_VLRSERVICOGERAL` double(18,8) NOT NULL,
  `QTO_PERCCONTRIBMARG` double(18,8) NOT NULL,
  `QTO_PERCISS` double(18,8) NOT NULL,
  `QTO_PERCICMS` double(18,8) NOT NULL,
  `QTO_PERCIPI` double(18,8) NOT NULL,
  `QTO_PERCPIS` double(18,8) NOT NULL,
  `QTO_PERCOUTROS` double(18,8) NOT NULL,
  `QTO_PERCCOFINS` double(18,8) NOT NULL,
  `QTO_PERCTAXAADMIN` double(18,8) NOT NULL,
  `QTO_PERCIMPRENDA` double(18,8) NOT NULL,
  `QTO_PERCCSLL` double(18,8) NOT NULL,
  `QTO_PERCSIMPLESFEDERAL` double(18,8) NOT NULL,
  `QTO_CALCULAISS` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULAICMS` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULAIPI` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULAPIS` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULACOFINS` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULASIMPLESFEDERAL` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULAIMPOSTORENDA` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULACSLL` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULATAXAADM` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULAOUTROS` char(1) NOT NULL DEFAULT '',
  `QTO_VLRSIMPLESESTADUAL` double(18,8) NOT NULL,
  `QTO_VLRICMSREVENDA` double(18,8) NOT NULL,
  `QTO_PERCICMSREVENDA` double(18,8) NOT NULL,
  `QTO_PERCSIMPLESESTADUAL` double(18,8) NOT NULL,
  `QTO_CALCULAICMSREVENDA` char(1) NOT NULL DEFAULT '',
  `QTO_CALCULASIMPLESESTADUAL` char(1) NOT NULL DEFAULT '',
  `QTO_VALORPRAZOANTIGO` double(18,8) NOT NULL,
  `QTO_VLRUNITPRAZOSEMIPI` double(18,8) NOT NULL,
  `QTO_VLRUNITVISTASEMIPI` double(18,8) NOT NULL,
  `QTO_VLRFINALVISTASEMIPI` double(18,8) NOT NULL,
  `QTO_VLRFINALPRAZOSEMIPI` double(18,8) NOT NULL,
  `QTO_QTPAPELARREDONDAMENTO` double(18,8) NOT NULL,
  `QTO_VLRPAPELARREDONDAMENTO` double(18,8) NOT NULL,
  `QTO_VLRACABAMENTOLP` double(18,8) NOT NULL,
  `QTO_TEMPOACABAMENTOLP` double(18,8) NOT NULL,
  `QTO_TEMPOIMPRESSAOLP` double(18,8) NOT NULL,
  `QTO_VLRIMPRESSAOLP` double(18,8) NOT NULL,
  `QTO_QTSERVGERALLP` double(18,8) NOT NULL,
  `QTO_VLRSERVGERALLP` double(18,8) NOT NULL,
  `QTO_QTSERVICOLP` double(18,8) NOT NULL,
  `QTO_VLRSERVICOLP` double(18,8) NOT NULL,
  `QTO_QTPAPELLP` double(18,8) NOT NULL,
  `QTO_VLRPAPELLP` double(18,8) NOT NULL,
  `QTO_QTCHAPASLP` int(11) NOT NULL,
  `QTO_VLRCHAPASLP` double(18,8) NOT NULL,
  `QTO_VLRSERVICOINTERNO` double(18,8) NOT NULL,
  `QTO_VLRACABAMENTOSOMENTE` double(18,8) NOT NULL,
  `QTO_PERCDESCLP` double(18,8) NOT NULL,
  `QTO_VLRDESCLP` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ORC_ID`,`QTO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOrcamento` (`EMP_ID`,`ORC_ID`),
  KEY `fkQtOrcamento` (`EMP_ID`,`ORC_ID`,`QTO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qualidadeimpressao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualidadeimpressao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOOP` varchar(20) NOT NULL DEFAULT '0',
  `CODIGOPERFIL` int(11) NOT NULL,
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIALITEM` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) DEFAULT NULL,
  `CONTEUDO` varchar(70) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) DEFAULT NULL,
  `DATAIMPRESSAO` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOOP`,`SEQUENCIAL`,`CODIGOPERFIL`,`SEQUENCIALITEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOP`),
  KEY `fkUsuario` (`CODIGOUSUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qualidadeperfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualidadeperfil` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOME` varchar(30) NOT NULL DEFAULT '',
  `ALTERARRESPOSTAS` char(1) DEFAULT 'S',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qualidadeperfilitens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualidadeperfilitens` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(150) NOT NULL DEFAULT '',
  `TAMANHO` int(11) NOT NULL DEFAULT '0',
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `ORDEM` int(11) NOT NULL DEFAULT '0',
  `VALORPADRAO` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPerfilQualid` (`EMP_ID`,`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `rateiocentrocustos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rateiocentrocustos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOCENTROCUSTOADM` int(11) NOT NULL DEFAULT '0',
  `CODIGOCENTROCUSTOPROD` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCRATEIO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOCENTROCUSTOADM`,`CODIGOCENTROCUSTOPROD`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCentroCustoAdm` (`EMP_ID`,`CODIGOCENTROCUSTOADM`),
  KEY `fkCentroCustoProd` (`EMP_ID`,`CODIGOCENTROCUSTOPROD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `rateiodespesas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rateiodespesas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREDUZIDO` int(11) NOT NULL DEFAULT '0',
  `CODIGOCENTROCUSTO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCRATEIO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOREDUZIDO`,`CODIGOCENTROCUSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOREDUZIDO`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `rateiofuncionarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rateiofuncionarios` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOFUNC` int(11) NOT NULL DEFAULT '0',
  `CODIGOCENTROCUSTO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PERCRATEIO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOFUNC`,`CODIGOCENTROCUSTO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFuncionario` (`EMP_ID`,`CODIGOFUNC`),
  KEY `fkCentroCusto` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `receber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receber` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOBANCO` varchar(20) DEFAULT NULL,
  `CODIGOCARTEIRA` varchar(20) DEFAULT NULL,
  `NUMEROBANCO` varchar(30) DEFAULT NULL,
  `LIQUIDACAODUVIDOSA` char(1) NOT NULL DEFAULT '',
  `DATAENVIO` datetime DEFAULT NULL,
  `FLAGFORAMGERADASCOMISSOES` char(1) DEFAULT NULL,
  `BOLETOENVIADOEMAIL` char(1) DEFAULT NULL,
  `EMAILENVIADO` varchar(100) DEFAULT NULL,
  `OCORRENCIAEMAIL` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CHAVE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkBanco` (`EMP_ID`,`CODIGOBANCO`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRA`),
  KEY `ak_remessa_receber` (`NUMEROBANCO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recibo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recibo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGORECIBO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOPESSOA` varchar(20) NOT NULL DEFAULT '',
  `NOMEPESSOA` varchar(50) NOT NULL DEFAULT '',
  `DATAEMISSAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `VALORRECIBO` double(18,8) NOT NULL,
  `CANCELADO` char(1) DEFAULT NULL,
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGORECIBO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`CODIGOPESSOA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reciboitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reciboitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGORECIBO` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `NUMERONF` int(11) NOT NULL DEFAULT '0',
  `NUMEROSERIENF` varchar(20) DEFAULT '',
  `NUMEROTITULO` varchar(20) DEFAULT '',
  `DATAPAGAMENTO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `VALORTOTAL` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGORECIBO`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recopi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recopi` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CLASSIFICACAO` int(10) unsigned NOT NULL,
  `DOC_ID` int(10) unsigned NOT NULL,
  `SEQUENCIALITEM` int(10) unsigned NOT NULL,
  `RECOPI_ID` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SERIENF` varchar(20) NOT NULL,
  `NUMERONF` int(10) unsigned NOT NULL,
  `STATUS` varchar(22) NOT NULL,
  `TIPOOPERACAO` varchar(32) NOT NULL,
  `DATAHORAEMISSAO` datetime DEFAULT NULL,
  `CODIGOCONTROLE` varchar(20) DEFAULT NULL,
  `AMBIENTE` varchar(15) DEFAULT NULL,
  `IPORIGEM` varchar(20) NOT NULL,
  `NOMEUSUARIO` varchar(30) NOT NULL,
  `PAPEL_ID` varchar(20) DEFAULT NULL,
  `PAPEL_NCM` varchar(20) NOT NULL,
  `PAPEL_QTDE` double(18,8) NOT NULL,
  `ORIGEM_ORCOP` varchar(20) NOT NULL,
  `STATUSSOLICITACAO` varchar(20) NOT NULL,
  `GARE_DATAEMISSAO` datetime NOT NULL,
  `GARE_VALOR` double(18,8) NOT NULL,
  `DOC_IDNFREFERENCIADA` int(11) NOT NULL,
  `SERIENFREFERENCIADA` varchar(20) NOT NULL,
  `NUMERONFREFERENCIADA` int(10) NOT NULL,
  `DATAEMISSAONFREFERENCIADA` datetime NOT NULL,
  `VALORLIQUIDONFREFERENCIADA` double(18,8) NOT NULL,
  `RETORNODATAENTRADAMERCADORIA` datetime NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CLASSIFICACAO`,`DOC_ID`,`SEQUENCIALITEM`,`RECOPI_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recopiocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recopiocorrencias` (
  `OCO_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(10) unsigned NOT NULL,
  `RECOPI_ID` int(10) unsigned NOT NULL,
  `SERIENF` varchar(20) DEFAULT NULL,
  `NUMERONF` int(10) unsigned DEFAULT NULL,
  `CODIGOCONTROLE` varchar(20) DEFAULT NULL,
  `DATAHORA` datetime NOT NULL,
  `STATUS` varchar(22) NOT NULL,
  `OCO_CODIGO` varchar(8) NOT NULL,
  `OCO_DESCRICAO` varchar(1024) DEFAULT NULL,
  `OCO_SOLUCAO` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`OCO_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkRecopi` (`EMP_ID`,`RECOPI_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recursocompromisso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recursocompromisso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `COM_ID` int(11) NOT NULL DEFAULT '0',
  `COR_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`COM_ID`,`COR_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `registrouso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrouso` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMESESSAO` varchar(50) NOT NULL DEFAULT '',
  `CHAVESESSAO` varchar(50) NOT NULL DEFAULT '',
  `DATASESSSAO` datetime NOT NULL,
  `USUARIOSESSAO` varchar(50) NOT NULL,
  `CATEGORIASESSAO` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `regrastributacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regrastributacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `RT_ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `RT_TIPO` varchar(20) NOT NULL DEFAULT '',
  `RT_UFVALIDA` varchar(100) DEFAULT NULL,
  `RT_DESCRICAO` varchar(200) NOT NULL DEFAULT '',
  `RT_TIPOCLIENTE` varchar(50) DEFAULT NULL,
  `RT_TIPOPROD` varchar(50) DEFAULT NULL,
  `RT_CFOP` varchar(5) NOT NULL DEFAULT '',
  `RT_CST_ICMS` varchar(3) DEFAULT NULL,
  `RT_PER_ICMS` double(18,8) DEFAULT NULL,
  `RT_IPI` char(1) DEFAULT NULL,
  `RT_CST_IPI` varchar(3) DEFAULT NULL,
  `RT_PER_IPI` double(18,8) DEFAULT NULL,
  `RT_CST_PIS` varchar(3) DEFAULT NULL,
  `RT_PER_PIS` double(18,8) DEFAULT NULL,
  `RT_CST_COFINS` varchar(3) DEFAULT NULL,
  `RT_PER_COFINS` double(18,8) DEFAULT NULL,
  `RT_CST_SERVICO` varchar(3) DEFAULT NULL,
  `RT_PER_SERVICO` double(18,8) DEFAULT NULL,
  `RT_PER_MVA` double(18,8) DEFAULT NULL,
  `RT_DESATIVADA` char(1) DEFAULT NULL,
  `RT_TPOPERACAO` varchar(50) NOT NULL,
  `RT_PER_REDUCAOBC` double(18,8) DEFAULT NULL,
  `RT_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `RT_MOTIVODESONERACAOICMS` varchar(30) DEFAULT NULL,
  `RT_PER_ICMS_DESONERACAO` double(18,8) DEFAULT NULL,
  `RT_PER_DESC` double(18,8) DEFAULT '0.00000000',
  PRIMARY KEY (`RT_ID`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `relacaocheque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relacaocheque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `CONTABANCOCHEQUE` int(11) NOT NULL DEFAULT '0',
  `AGENCIABANCOCHEQUE` int(11) NOT NULL DEFAULT '0',
  `NROBANCOCHEQUE` int(11) NOT NULL DEFAULT '0',
  `DIGITOCONTA` varchar(5) NOT NULL DEFAULT '0',
  `DIGITOAGENCIA` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`CHAVE`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `remessacobranca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remessacobranca` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREMESSA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAGERACAOARQUIVO` datetime DEFAULT NULL,
  `NOMEARQUIVO` varchar(40) NOT NULL DEFAULT '',
  `CODIGOCARTEIRA` varchar(10) NOT NULL DEFAULT '',
  `DESCRICAOCARTEIRA` varchar(70) NOT NULL DEFAULT '',
  `NOMECEDENTE` varchar(70) NOT NULL DEFAULT '',
  `INSTRUCOES` varchar(240) DEFAULT NULL,
  `SEQUENCIALREMESSA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOREMESSA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCarteira` (`EMP_ID`,`CODIGOCARTEIRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `remessacobrancalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remessacobrancalog` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `LOG_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOREMESSA` int(11) DEFAULT '0',
  `DATAGERACAOLOG` datetime DEFAULT NULL,
  `USUARIO` varchar(30) DEFAULT NULL,
  `OBSERVACAO` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`LOG_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkRemessa` (`EMP_ID`,`CODIGOREMESSA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `remessacobrancatitulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remessacobrancatitulos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREMESSA` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CHAVE` int(11) NOT NULL DEFAULT '0',
  `NUMEROTITULO` varchar(20) NOT NULL DEFAULT '',
  `VALOR` double(18,8) NOT NULL,
  `IMPRESSO` char(1) NOT NULL DEFAULT '',
  `NOMEPESSOA` varchar(60) NOT NULL DEFAULT '',
  `NOSSONUMERO` varchar(30) NOT NULL DEFAULT '',
  `SERIENF` varchar(30) NOT NULL DEFAULT '',
  `NUMERONF` int(11) NOT NULL DEFAULT '0',
  `CANCELADA` char(1) NOT NULL DEFAULT 'N',
  `STATUS` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOREMESSA`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkRemessa` (`EMP_ID`,`CODIGOREMESSA`),
  KEY `ak_remessa_chave` (`CHAVE`),
  KEY `ak_remessa_nossonumero` (`NOSSONUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `requisicaoestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requisicaoestoque` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAOPERACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `JUSTIFICATIVA` varchar(100) DEFAULT NULL,
  `REQUISITANTE` varchar(20) DEFAULT NULL,
  `NUMEROPEDIDO` varchar(20) DEFAULT NULL,
  `SEQUENCIALITEMPEDIDO` int(11) DEFAULT NULL,
  `CODIGOOS` varchar(20) DEFAULT NULL,
  `DESCRICAOOS` longtext,
  `CODIGOCLIENTE` varchar(20) DEFAULT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL DEFAULT '0',
  `LOGINUSUARIO` varchar(20) NOT NULL DEFAULT '',
  `NOMEUSUARIO` varchar(30) NOT NULL DEFAULT '',
  `DATAGRAVACAO` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `REQUISICAOAUTOMATICA` char(1) DEFAULT '',
  `DATAULTIMAMODIFICACAO` datetime DEFAULT NULL,
  `CODTIPOMOVESTOQUE` varchar(20) DEFAULT NULL,
  `SPED` char(1) DEFAULT NULL,
  `CODIGOCENTROCUSTO` int(11) DEFAULT NULL,
  `CANCELADO` char(1) NOT NULL,
  `DATACANCELAMENTO` datetime DEFAULT NULL,
  `IDUSUARIOCANCELAMENTO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkOP` (`EMP_ID`,`CODIGOOS`),
  KEY `fkCliente` (`EMP_ID`,`CODIGOCLIENTE`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `fkTipoMovEstoque` (`EMP_ID`,`CODTIPOMOVESTOQUE`),
  KEY `fkCentroCustoReq` (`EMP_ID`,`CODIGOCENTROCUSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `requisicaoestoqueitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requisicaoestoqueitem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOREQUISICAO` int(11) NOT NULL,
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `ORIGEMMATERIAL` char(1) NOT NULL DEFAULT '',
  `CODIGOMATERIAL` varchar(20) NOT NULL DEFAULT '',
  `DESCRICAOMATERIAL` varchar(200) NOT NULL DEFAULT '',
  `QUANTIDADE` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) DEFAULT NULL,
  `CODIGOCOMPONENTE` int(11) DEFAULT NULL,
  `SALDO` double(18,8) NOT NULL,
  `ITEMMANUAL` char(1) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOREQUISICAO`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkReqEstoque` (`EMP_ID`,`CODIGOREQUISICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `salesforcehistorico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesforcehistorico` (
  `EMP_ID` int(11) DEFAULT NULL,
  `PROP_ID` int(11) DEFAULT NULL,
  `IDCOT` varchar(50) DEFAULT NULL,
  `ATUALIZACAO_DATA` datetime DEFAULT NULL,
  `ATUALIZACAO_STATUS` varchar(3) DEFAULT NULL,
  `CONTEUDO_JSON` varchar(5000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `scriptcalculoorcamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scriptcalculoorcamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL,
  `SCRIPTCALCULO` longtext NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_SCRIPT`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `scriptcalculoorcamentoparametro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scriptcalculoorcamentoparametro` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMEPARAMETRO` varchar(50) NOT NULL,
  `VALORPARAMETRO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_SCRIPT`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `scriptcalculoorcamentoparametromaterial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scriptcalculoorcamentoparametromaterial` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_SCRIPT` int(11) NOT NULL DEFAULT '0',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NOMECODMATN` varchar(50) NOT NULL,
  `NOMEORIGEMMATN` varchar(50) NOT NULL,
  `NOMEQTDMATN` varchar(50) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`ID_SCRIPT`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `serienf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serienf` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `IDSERIE` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `NUMEROULTIMANOTA` int(11) NOT NULL DEFAULT '0',
  `GERARNSU` char(1) DEFAULT NULL,
  `NFE` char(1) DEFAULT NULL,
  `NFCE` char(1) DEFAULT NULL,
  `MDFE` char(1) DEFAULT NULL,
  `NFSE` char(1) DEFAULT NULL,
  `SPED` char(1) DEFAULT NULL,
  `SCAN` char(1) DEFAULT 'N',
  `NFSEULTIMOIDLOTE` int(10) DEFAULT '0',
  `NFSEULTIMOIDLOTEENVIO` int(10) DEFAULT '0',
  `NFSEULTIMOIDLOTEENVIOTESTE` int(10) DEFAULT '0',
  `NFSEULTIMOIDRPS` int(10) DEFAULT '0',
  `NFSEULTIMOIDRPSTESTE` int(10) DEFAULT '0',
  `PREFERENCIAL` char(1) NOT NULL DEFAULT '',
  `HOMOLOGACAO` char(1) DEFAULT NULL,
  `CODIGOTIPODOCPADRAO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`IDSERIE`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `serienfdispositivolegal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serienfdispositivolegal` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGODISPOSITIVOLEGAL` varchar(30) NOT NULL DEFAULT '',
  `IDSERIENF` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGODISPOSITIVOLEGAL`,`IDSERIENF`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkDispLegal` (`EMP_ID`,`CODIGODISPOSITIVOLEGAL`),
  KEY `fkSerieNF` (`EMP_ID`,`IDSERIENF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `setor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `situacaotributaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `situacaotributaria` (
  `CST_ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `NUMERO` varchar(5) NOT NULL DEFAULT '',
  `DESCRICAO` varchar(125) DEFAULT NULL,
  `TIPO` varchar(20) NOT NULL DEFAULT '',
  `TRIBUTAVEL` varchar(1) NOT NULL DEFAULT '',
  `TRIBUTAVELST` varchar(1) NOT NULL DEFAULT '',
  `TRIBUTAVELDIFERIMENTO` varchar(1) NOT NULL DEFAULT 'N',
  `HABILITARPECREDUCAO` varchar(1) NOT NULL DEFAULT '',
  `IMPOSTOCOBRADOANTERIORMENTE` varchar(1) NOT NULL DEFAULT '',
  `HABILITARCREDITOICMS` varchar(1) NOT NULL DEFAULT 'N',
  `TIPOOPERACAO` char(1) DEFAULT NULL,
  `HABILITARDESONERACAO` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`CST_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `spedlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spedlog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `EMP_ID` int(11) NOT NULL,
  `TIPOSPED` varchar(20) NOT NULL,
  `USUARIOGEROUARQUIVO` varchar(20) DEFAULT NULL,
  `DATAHORAGERACAO` datetime DEFAULT NULL,
  `ARQUIVO` varchar(240) NOT NULL,
  `FILTROS` varchar(2000) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `statuscomanda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuscomanda` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `SCM_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SCM_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `SCM_PADRAOCOMANDA` char(1) NOT NULL,
  `SCM_PADRAONOTARAPIDA` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`SCM_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `statusproposta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statusproposta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `STP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `STP_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `STP_CONFIRMADO` char(1) NOT NULL DEFAULT '',
  `STP_PERCNEG` double(18,8) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`STP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `statuspropostafat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuspropostafat` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'Código da empresa',
  `STP_ID` varchar(20) NOT NULL DEFAULT '' COMMENT 'Código do status da proposta',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `STP_DESCRICAO` varchar(50) NOT NULL DEFAULT '' COMMENT 'Descrição do status proposta',
  `STP_FATURADO` char(1) NOT NULL DEFAULT '' COMMENT 'Faturado',
  `STP_PERCNEG` double(18,8) DEFAULT NULL COMMENT 'Percentual da negociação',
  PRIMARY KEY (`STP_ID`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `subgrupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subgrupo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `GRU_ID` varchar(20) NOT NULL DEFAULT '',
  `SGR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SGR_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`GRU_ID`,`SGR_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tarefa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CODIGOSETOR` int(11) NOT NULL DEFAULT '0',
  `CODIGOSTATUSOP` int(11) NOT NULL DEFAULT '0',
  `DESMEMBRARMIOLO` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkSetor` (`EMP_ID`,`CODIGOSETOR`),
  KEY `fkPCPCodigoStatusOP` (`EMP_ID`,`CODIGOSTATUSOP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tarefadependencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefadependencias` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTAREFA` int(11) NOT NULL DEFAULT '0',
  `CODIGOTAREFADEPENDENTE` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTAREFA`,`CODIGOTAREFADEPENDENTE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTarefa` (`EMP_ID`,`CODIGOTAREFA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tarefaocorrencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefaocorrencias` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTAREFA` int(11) NOT NULL DEFAULT '0',
  `CODIGOOCORRENCIA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAOOCORRENCIA` varchar(50) NOT NULL DEFAULT '',
  `ATIVADA` char(1) NOT NULL DEFAULT '',
  `FINALIZADA` char(1) NOT NULL DEFAULT '',
  `SUSPENDIDA` char(1) NOT NULL DEFAULT '',
  `CODIGOTIPOTEMPO` int(11) NOT NULL DEFAULT '0',
  `QTESTOQUE` char(1) NOT NULL DEFAULT '',
  `CODIGOUNDCONTAGEM` int(11) NOT NULL DEFAULT '0',
  `TROCAOPERADOR` char(1) NOT NULL DEFAULT '',
  `MOVERFINALFILA` char(1) NOT NULL DEFAULT '',
  `PEDIROBSERVACAO` char(1) NOT NULL,
  `EXPEDIR` char(1) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTAREFA`,`CODIGOOCORRENCIA`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTarefa` (`EMP_ID`,`CODIGOTAREFA`),
  KEY `fkOcorrencia` (`EMP_ID`,`CODIGOOCORRENCIA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `taxas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxas` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TX_DESCRICAO` varchar(200) NOT NULL DEFAULT '',
  `IDMEIOPAGAMENTO` int(11) NOT NULL DEFAULT '0',
  `IDINSTITUICAOPAGAMENTO` int(11) NOT NULL DEFAULT '0',
  `TX_PERCTAXA` double(18,8) DEFAULT '0.00000000',
  `TX_DIASLIQUIDACAO` int(11) DEFAULT '0',
  `TX_DESATIVADA` int(1) DEFAULT '0' COMMENT '0 - Não | 1 - Sim ',
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinta` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TIN_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TIN_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIN_FATORABSORCAO` double(18,8) NOT NULL,
  `TIN_VALOR` double(18,8) NOT NULL,
  `TIN_SALDOINICIAL` double(18,8) DEFAULT NULL,
  `TIN_QTMINIMA` double(18,8) DEFAULT NULL,
  `TIN_SALDOFISICO` double(18,8) DEFAULT NULL,
  `TIN_SALDOEMPENHADO` double(18,8) DEFAULT NULL,
  `TIN_CODIGOFORNECEDOR` varchar(20) DEFAULT NULL,
  `CODIGOREFERENCIA` varchar(35) DEFAULT NULL,
  `TIN_PRECOMEDIO` double(18,5) DEFAULT '0.00000',
  `TIN_CSTICMS` varchar(3) DEFAULT NULL,
  `TIN_CSTIPI` varchar(3) DEFAULT NULL,
  `TIN_CSTPIS` varchar(3) DEFAULT NULL,
  `TIN_CSTCOFINS` varchar(3) DEFAULT NULL,
  `TIN_CNAE` varchar(10) DEFAULT NULL,
  `TIN_CLASSFISCAL` varchar(10) DEFAULT NULL,
  `TIN_PERCIPI` double(18,8) DEFAULT NULL,
  `TIN_PERCICMS` double(18,8) DEFAULT NULL,
  `TIN_TIPOITEM` char(2) DEFAULT NULL,
  `TIN_SALDOEMPENHADOVENDA` double(18,8) DEFAULT NULL,
  `TIN_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TIN_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TIN_SALDOEMPENHADOPRODUCAO` double(18,8) DEFAULT NULL,
  `TIN_VERNIZEMLINHA` char(1) NOT NULL,
  `TIN_VALORSEMICMSIPI` double(18,8) DEFAULT NULL,
  `TIN_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `INFORMARVALORMEDIOMANUAL` char(1) DEFAULT 'N',
  `TIN_CODPLANOCONTA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`TIN_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkFornecedor` (`EMP_ID`,`TIN_CODIGOFORNECEDOR`),
  KEY `fkPlanoConta` (`EMP_ID`,`TIN_CODPLANOCONTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoatendimento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoatendimento` (
  `TPA_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPA_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TPA_DESATIVADO` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`TPA_ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipocargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipocargo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipodocumento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipodocumento` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `CLASSIFICACAO` int(11) NOT NULL,
  `INDICADOROPERACAO` varchar(20) NOT NULL DEFAULT '',
  `FINALIDADEEMISSAO` varchar(20) NOT NULL DEFAULT '',
  `GERARCOMISSAOGERAL` char(1) NOT NULL DEFAULT '',
  `PREFATURA` char(1) NOT NULL DEFAULT '',
  `PEDIDOORCAMENTO` varchar(1) NOT NULL DEFAULT 'N',
  `NATOPERACAODESC` varchar(100) NOT NULL,
  `BAIXARESTOQUE` char(1) NOT NULL DEFAULT 'N',
  `NAT_ID` varchar(30) DEFAULT NULL,
  `CODIGOPLANOCONTA` int(10) DEFAULT NULL,
  `TPOPERACAO_ID` varchar(30) DEFAULT NULL,
  `TPD_NOTANFAE` char(1) NOT NULL DEFAULT 'N',
  `TPD_INDICADORPRESENCA` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkNatOP` (`EMP_ID`,`NAT_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`CODIGOPLANOCONTA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipodocumentofinanceiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipodocumentofinanceiro` (
  `ID` int(11) NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPF_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `DIACOMPENSACAO` int(11) NOT NULL,
  `TIPOMEIOPAGTO` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `akTrigger1` (`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoembalagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoembalagem` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CODIGOMATERIAL` varchar(20) DEFAULT NULL,
  `DESCRICAOEMBALAGEM` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkMaterial` (`EMP_ID`,`CODIGOMATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpresso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpresso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPI_DESCRICAO` longtext NOT NULL,
  `TPI_TIPOIMPRESSO` varchar(20) NOT NULL DEFAULT '',
  `TPI_PRODUTOSERVICO` varchar(20) NOT NULL DEFAULT '',
  `TPI_NROVIAS` int(11) DEFAULT NULL,
  `TPI_TEMCAPA` char(1) DEFAULT NULL,
  `TPI_TEMCARBONO` char(1) DEFAULT NULL,
  `TPI_PERCIPI` double(18,8) DEFAULT NULL,
  `TPI_TIPOVALORPAPEL` varchar(20) NOT NULL DEFAULT '',
  `TPI_CST` varchar(5) DEFAULT NULL,
  `TPI_CODIGONCM` varchar(20) DEFAULT NULL,
  `TPI_DESATIVADO` char(1) NOT NULL DEFAULT '',
  `TPI_PERCINDESTPAPEL` double(18,8) NOT NULL,
  `TPI_OBSERVACOES` longtext,
  `TPI_COPIAROBSORC` char(1) NOT NULL DEFAULT '',
  `TPI_CSTIP` varchar(20) DEFAULT NULL,
  `TPI_CSTPIS` varchar(20) DEFAULT NULL,
  `TPI_CSTCOFINS` varchar(20) DEFAULT NULL,
  `TPI_CNAE` varchar(10) DEFAULT NULL,
  `TPR_IDTIPOPRODFSC` varchar(20) DEFAULT NULL,
  `CODPERFILIMPOSTO` int(11) DEFAULT NULL,
  `TPI_ORIGEMTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TPI_TIPOTRIBUTACAO` varchar(50) DEFAULT NULL,
  `TPI_CREDITAICMSIPI` char(1) DEFAULT NULL,
  `TPI_CREDITAPISCOFINS` char(1) DEFAULT NULL,
  `CODIDENTIFICADOROP` int(11) DEFAULT NULL,
  `CODIDENTIFICADOROP2` int(11) DEFAULT NULL,
  `TPI_CODENQUADRAMENTOIPI` varchar(3) DEFAULT NULL,
  `TPI_PERCMARGEMLUCRO` double(18,8) DEFAULT NULL,
  `SALESFORCE_IDPRODUTO` varchar(50) DEFAULT NULL,
  `SALESFORCE_IDTABELAPRECO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPerfilImposto` (`EMP_ID`,`CODPERFILIMPOSTO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressomaqacab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressomaqacab` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPA_INFORMATIVO` varchar(10) NOT NULL DEFAULT '',
  `SEQUENCIALEXECUCAO` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`MAQ_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressomaqacablam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressomaqacablam` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `TPL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SEQUENCIALEXECUCAO` int(11) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`MAQ_ID`,`TPL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkTipoLamImpresso` (`EMP_ID`,`TPI_ID`,`TPL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressomaqacabmatdiv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressomaqacabmatdiv` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `MAQ_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MTR_ID` varchar(20) DEFAULT '',
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `QTCONSUMO` double(18,8) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL DEFAULT '',
  `UNIDADECONSUMO` varchar(10) NOT NULL DEFAULT '',
  `QTMINIMACONSUMO` double(18,8) NOT NULL,
  `VALOR` double(18,8) NOT NULL,
  `CALCULAUSANDOFORMULA` char(1) NOT NULL DEFAULT '',
  `CODIGOFORMULA` int(11) NOT NULL DEFAULT '0',
  `FOR_IDQUANT` int(11) NOT NULL DEFAULT '0',
  `FOR_IDVALOR` int(11) NOT NULL DEFAULT '0',
  `QTCONSUMO2` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`MAQ_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkMaquina` (`EMP_ID`,`MAQ_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormula1` (`CODIGOFORMULA`),
  KEY `fkFormula2` (`FOR_IDQUANT`),
  KEY `fkFormula3` (`FOR_IDVALOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressomatdiverso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressomatdiverso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`MTR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressoservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressoservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPS_INFORMATIVO` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`OSR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressoservicolam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressoservicolam` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `TPL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`OSR_ID`,`TPL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkTipoLamImpresso` (`EMP_ID`,`TPI_ID`,`TPL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoimpressoservicomatdiv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoimpressoservicomatdiv` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `OSR_ID` varchar(20) NOT NULL DEFAULT '',
  `MTR_ID` varchar(20) NOT NULL DEFAULT '',
  `ORIGEM` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `FOR_IDQUANT` int(11) NOT NULL DEFAULT '0',
  `FOR_IDVALOR` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`OSR_ID`,`MTR_ID`,`ORIGEM`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkOrcServ` (`EMP_ID`,`OSR_ID`),
  KEY `fkMaterial` (`EMP_ID`,`MTR_ID`),
  KEY `fkFormulaquant` (`FOR_IDQUANT`),
  KEY `fkFormulavalor` (`FOR_IDVALOR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipolaminaimpresso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipolaminaimpresso` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPI_ID` varchar(20) NOT NULL DEFAULT '',
  `TPL_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPL_TIPOLAMINA` varchar(30) NOT NULL DEFAULT '',
  `TPL_GRAMATURAPAPEL` double(18,8) NOT NULL,
  `TPL_CORFRENTE` int(11) NOT NULL DEFAULT '0',
  `TPL_CORVERSO` int(11) NOT NULL DEFAULT '0',
  `TPL_COBRAACERTO` char(1) NOT NULL DEFAULT '',
  `TPL_COBRACHAPA` char(1) NOT NULL DEFAULT '',
  `TPL_COBRALAVACAO` char(1) NOT NULL DEFAULT '',
  `TPP_ID` int(11) NOT NULL DEFAULT '0',
  `TPL_TIPOLAMINADESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TPL_SANGRIA` double NOT NULL,
  PRIMARY KEY (`EMP_ID`,`TPI_ID`,`TPL_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTipoImpresso` (`EMP_ID`,`TPI_ID`),
  KEY `fkPapel` (`EMP_ID`,`TPP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipolote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipolote` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ID_TIPOLOTE` varchar(20) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(80) NOT NULL,
  `UTILIZARMASC` char(1) NOT NULL,
  `MASCARA` varchar(40) NOT NULL,
  `VARIAVEISUTILIZADAS` varchar(40) NOT NULL,
  `ULTIMOSEQLOTE` int(11) NOT NULL,
  `FSC` char(1) NOT NULL,
  `PRODUTOACABADO` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`EMP_ID`,`ID_TIPOLOTE`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipomapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipomapa` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGOTIPOMAPA` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGOTIPOMAPA`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipomovimentacaoestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipomovimentacaoestoque` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `CODIGO` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(100) NOT NULL DEFAULT '',
  `GERARESTOQUE` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipooperacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipooperacao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPOP_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPOP_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`TPOP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipopapel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipopapel` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPP_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TPP_DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TPP_PERCPRODUTIVIDADE` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`TPP_ID`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoprodutofsc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoprodutofsc` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `TPR_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `GPR_ID` varchar(20) NOT NULL DEFAULT '',
  `TPR_DESCRICAO` varchar(300) NOT NULL DEFAULT '',
  `DECLARACAO` varchar(50) NOT NULL DEFAULT '',
  `SISTEMACONTROLE` varchar(50) NOT NULL DEFAULT '',
  `ESPECIES` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`TPR_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkGrupoFSC` (`EMP_ID`,`GPR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipospagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipospagamento` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipostatusordemservico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipostatusordemservico` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tipoturno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoturno` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `transferenciaempresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transferenciaempresas` (
  `TRS_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `TRS_EMPSAIDA` int(11) NOT NULL DEFAULT '0',
  `TRS_EMPENTRADA` int(11) NOT NULL DEFAULT '0',
  `TRS_TIPOOPERACAO` varchar(20) NOT NULL,
  `TRS_ORIGEMITEM` varchar(20) NOT NULL,
  `TRS_CODPRODUTO` varchar(20) NOT NULL,
  `TRS_DOCCLASSSAIDA` int(10) NOT NULL,
  `TRS_DOC_IDSAIDA` int(10) NOT NULL,
  `TRS_DOCSEQITEMSAIDA` int(10) NOT NULL,
  `TRS_DTTRANSFERENCIA` datetime NOT NULL,
  `TRS_QTDTRANSFERIDA` double(18,8) NOT NULL,
  `TRS_NOMEUSUARIO` varchar(30) NOT NULL,
  `TRS_STATUS` varchar(30) NOT NULL,
  `TRS_DTRECEBIMENTO` datetime DEFAULT NULL,
  `TRS_DOCCLASSENTRADA` int(10) DEFAULT NULL,
  `TRS_DOC_IDENTRADA` int(10) DEFAULT NULL,
  `TRS_DOCSEQITEMENTRADA` int(10) DEFAULT NULL,
  PRIMARY KEY (`TRS_ID`),
  KEY `fkEmpresasaida` (`TRS_EMPSAIDA`),
  KEY `fkEmpresaentrada` (`TRS_EMPENTRADA`),
  KEY `akTransferencia01` (`TRS_EMPENTRADA`,`TRS_DOC_IDENTRADA`,`TRS_DOCCLASSENTRADA`,`TRS_DOCSEQITEMENTRADA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `transportadora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transportadora` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PCO_ID` int(11) DEFAULT '0',
  `FOP_ID` varchar(20) DEFAULT '',
  `ATI_ID` varchar(20) DEFAULT '',
  `PCO_IDPASSIVO` int(11) DEFAULT '0',
  `RNTRC` varchar(8) DEFAULT NULL,
  `TIPOPROPRIETARIO` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`PCO_ID`),
  KEY `fkFormaPagto` (`EMP_ID`,`FOP_ID`),
  KEY `fkAtividade` (`EMP_ID`,`ATI_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `turno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turno` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `CODIGO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `TIPO` int(11) NOT NULL DEFAULT '0',
  `DOMHORAINICIOPARTE1` time DEFAULT NULL,
  `DOMHORAFIMPARTE1` time DEFAULT NULL,
  `DOMINTERVALO` int(11) DEFAULT NULL,
  `DOMHORAINICIOPARTE2` time DEFAULT NULL,
  `DOMHORAFIMPARTE2` time DEFAULT NULL,
  `SEGHORAINICIOPARTE1` time DEFAULT NULL,
  `SEGHORAFIMPARTE1` time DEFAULT NULL,
  `SEGINTERVALO` int(11) DEFAULT NULL,
  `SEGHORAINICIOPARTE2` time DEFAULT NULL,
  `SEGHORAFIMPARTE2` time DEFAULT NULL,
  `TERHORAINICIOPARTE1` time DEFAULT NULL,
  `TERHORAFIMPARTE1` time DEFAULT NULL,
  `TERINTERVALO` int(11) DEFAULT NULL,
  `TERHORAINICIOPARTE2` time DEFAULT NULL,
  `TERHORAFIMPARTE2` time DEFAULT NULL,
  `QUAHORAINICIOPARTE1` time DEFAULT NULL,
  `QUAHORAFIMPARTE1` time DEFAULT NULL,
  `QUAINTERVALO` int(11) DEFAULT NULL,
  `QUAHORAINICIOPARTE2` time DEFAULT NULL,
  `QUAHORAFIMPARTE2` time DEFAULT NULL,
  `QUIHORAINICIOPARTE1` time DEFAULT NULL,
  `QUIHORAFIMPARTE1` time DEFAULT NULL,
  `QUIINTERVALO` int(11) DEFAULT NULL,
  `QUIHORAINICIOPARTE2` time DEFAULT NULL,
  `QUIHORAFIMPARTE2` time DEFAULT NULL,
  `SEXHORAINICIOPARTE1` time DEFAULT NULL,
  `SEXHORAFIMPARTE1` time DEFAULT NULL,
  `SEXINTERVALO` int(11) DEFAULT NULL,
  `SEXHORAINICIOPARTE2` time DEFAULT NULL,
  `SEXHORAFIMPARTE2` time DEFAULT NULL,
  `SABHORAINICIOPARTE1` time DEFAULT NULL,
  `SABHORAFIMPARTE1` time DEFAULT NULL,
  `SABINTERVALO` int(11) DEFAULT NULL,
  `SABHORAINICIOPARTE2` time DEFAULT NULL,
  `SABHORAFIMPARTE2` time DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CODIGO`),
  KEY `fkEmpresa` (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `veiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `veiculo` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `VEICULO` varchar(50) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `PROPRIO` int(11) DEFAULT NULL COMMENT '0 = Nao, 1 = Sim',
  `REBOQUE` int(11) DEFAULT NULL COMMENT '0 = Nao, 1 = Sim',
  `IDTIPOCARROCERIA` int(11) DEFAULT NULL,
  `PLACA` varchar(7) DEFAULT NULL,
  `RENAVAM` varchar(11) DEFAULT NULL,
  `UFLICENCIAMENTO` char(2) DEFAULT NULL,
  `TARA_KG` int(11) DEFAULT NULL,
  `CAPACIDADE_KG` int(11) DEFAULT NULL,
  `CAPACIDADE_M3` int(11) DEFAULT NULL,
  `IDTIPORODADO` int(11) DEFAULT NULL,
  `IDTRANSPORTADORA` varchar(20) DEFAULT NULL,
  `IDCONDUTORPRINCIPAL` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkTransportadora` (`EMP_ID`,`IDTRANSPORTADORA`),
  KEY `fkCondutor` (`EMP_ID`,`IDCONDUTORPRINCIPAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `VEN_REGIAOVENDAS` varchar(30) NOT NULL DEFAULT '',
  `VEN_PERCCOMISSAO` double(18,8) NOT NULL,
  `VEN_CLASSIFICACAO` varchar(20) NOT NULL DEFAULT '',
  `VEN_NROCORE` varchar(30) NOT NULL DEFAULT '',
  `VEN_CREDITOCOMISSOES` double(18,8) DEFAULT NULL,
  `VEN_PERCMEDIOCOMISSOES` double(18,8) DEFAULT NULL,
  `VEN_VLRVENDASANO` double(18,8) DEFAULT NULL,
  `VEN_DTMAIORVENDA` datetime DEFAULT NULL,
  `VEN_VLRMAIORVENDA` double(18,8) DEFAULT NULL,
  `VEN_DTULTIMAVENDA` datetime DEFAULT NULL,
  `VEN_VLRULTIMAVENDA` double(18,8) DEFAULT NULL,
  `VEN_TIPOPGTOCOMISSAO` varchar(20) DEFAULT NULL,
  `PCO_ID` int(11) NOT NULL DEFAULT '0',
  `VEN_GERENTEVENDAS_ID` varchar(20) DEFAULT NULL,
  `VEN_NAOCONSIDERARIMPOSTOCALCCOM` char(1) NOT NULL,
  `TIPODIASVENCIMENTO` varchar(20) DEFAULT NULL,
  `DIASSEMANA` longtext,
  `DIASESPECIFICOS` longtext,
  `INICIARCONTAGEMPROXMES` char(1) DEFAULT NULL,
  `TIPOTABELAVARIACAOCOMISSAO` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkPlanoConta` (`EMP_ID`,`PCO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `vendedormetavenda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedormetavenda` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DTMETAVENDA` datetime DEFAULT NULL,
  `VLRMETAVENDA` double(18,8) DEFAULT NULL,
  `QUANTIDADECLIENTES` int(11) DEFAULT '0',
  `QUANTIDADECIDADES` int(11) DEFAULT '0',
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`SEQUENCIAL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `vendedorprodutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedorprodutor` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `PROD_ID` varchar(20) NOT NULL DEFAULT '',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`PROD_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkPessoa` (`EMP_ID`,`PES_ID`),
  KEY `fkProdutor` (`EMP_ID`,`PROD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `vendedorvariacaocomissao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedorvariacaocomissao` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `PES_ID` varchar(20) NOT NULL DEFAULT '',
  `SEQUENCIAL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `MARGEMINICIAL` double(18,8) NOT NULL,
  `MARGEMFINAL` double(18,8) NOT NULL,
  `PERCVARIACAO` double(18,8) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`PES_ID`,`SEQUENCIAL`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoarte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoarte` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `CLI_ID` varchar(20) DEFAULT '',
  `CON_ID` int(11) DEFAULT '0',
  `USUARIO_CADASTRO` varchar(30) NOT NULL DEFAULT '',
  `DATA_CADASTRO` datetime NOT NULL,
  `ORIGEMPRODUTO` varchar(20) DEFAULT NULL,
  `ID_PRODUTOSERVICO` varchar(11) DEFAULT NULL,
  `DETALHAMENTO` longtext,
  `TIPOARTE` varchar(15) DEFAULT '',
  `DATA_ENTREGA` datetime DEFAULT NULL,
  `PRIORIDADE` varchar(15) NOT NULL DEFAULT '',
  `PEDIDOFECHADO` char(1) NOT NULL DEFAULT '',
  `SITUACAO` varchar(30) NOT NULL DEFAULT '',
  `FORMAAPROVACAO` varchar(30) DEFAULT '',
  `USUARIO_DESENVOLVIMENTO` varchar(30) DEFAULT '',
  `USUARIO_APROVACAO` varchar(30) DEFAULT '',
  `USUARIO_CANCELAMENTO` varchar(30) DEFAULT '',
  `DATA_CANCELAMENTO` datetime DEFAULT NULL,
  `JUSTIFICATIVACANCELAMENTO` longtext,
  `XCA_GABLOGO` char(1) NOT NULL,
  `XCA_GABFONE` char(1) NOT NULL,
  `XCA_GABEMAIL` char(1) NOT NULL,
  `XCA_GABSITE` char(1) NOT NULL,
  `XCA_GABPOLICARBONATO` char(1) NOT NULL,
  `XCA_GABACOESCOVADO` char(1) NOT NULL,
  `XCA_GABVINILESCOVADO` char(1) NOT NULL,
  `XCA_GABOUTROS` char(1) NOT NULL,
  `XCA_GABDESCOUTROS` varchar(200) DEFAULT NULL,
  `XCA_GABDETALHAMENTO` longtext,
  `XCA_GABTAMANHO` varchar(50) DEFAULT NULL,
  `XCA_ETQLOGO` char(1) NOT NULL,
  `XCA_ETQFONE` char(1) NOT NULL,
  `XCA_ETQEMAIL` char(1) NOT NULL,
  `XCA_ETQSITE` char(1) NOT NULL,
  `XCA_ETQPOLICARBONATO` char(1) NOT NULL,
  `XCA_ETQACOESCOVADO` char(1) NOT NULL,
  `XCA_ETQVINILESCOVADO` char(1) NOT NULL,
  `XCA_ETQOUTROS` char(1) NOT NULL,
  `XCA_ETQDESCOUTROS` varchar(200) DEFAULT NULL,
  `XCA_ETQDETALHAMENTO` longtext,
  `XCA_ETQTAMANHO` varchar(50) DEFAULT NULL,
  `XCA_SELOANOS` char(1) NOT NULL,
  `XCA_SELOMESES` char(1) NOT NULL,
  `XCA_SELOSEMANAS` char(1) NOT NULL,
  `XCA_SELOFRASES` char(1) NOT NULL,
  `XCA_SELODIAS` char(1) NOT NULL,
  `XCA_SELOLOGO` char(1) NOT NULL,
  `XCA_SELOFONE` char(1) NOT NULL,
  `XCA_SELOEMAIL` char(1) NOT NULL,
  `XCA_SELOSITE` char(1) NOT NULL,
  `XCA_SELOOUTROS` char(1) NOT NULL,
  `XCA_SELODESCOUTROS` varchar(200) DEFAULT NULL,
  `XCA_SELODETALHAMENTO` longtext,
  `XCA_SELOTAMANHO` varchar(50) DEFAULT NULL,
  `XCA_CAPALOGO` char(1) NOT NULL,
  `XCA_CAPAFONE` char(1) NOT NULL,
  `XCA_CAPAEMAIL` char(1) NOT NULL,
  `XCA_CAPASITE` char(1) NOT NULL,
  `XCA_CAPAENDERECO` char(1) NOT NULL,
  `XCA_CAPACIDADE` char(1) NOT NULL,
  `XCA_CAPAOUTROS` char(1) NOT NULL,
  `XCA_CAPADESCOUTROS` varchar(200) DEFAULT NULL,
  `XCA_CAPADETALHAMENTO` longtext,
  `XCA_MOUSEPADLOGO` char(1) NOT NULL,
  `XCA_MOUSEPADFONE` char(1) NOT NULL,
  `XCA_MOUSEPADEMAIL` char(1) NOT NULL,
  `XCA_MOUSEPADSITE` char(1) NOT NULL,
  `XCA_MOUSEPADCIDADE` char(1) NOT NULL,
  `XCA_MOUSEPADENDERECO` char(1) NOT NULL,
  `XCA_MOUSEPADPOLISAN` char(1) NOT NULL,
  `XCA_MOUSEPADTECIDO` char(1) NOT NULL,
  `XCA_MOUSEPADTRANSFER` char(1) NOT NULL,
  `XCA_MOUSEPADOUTROS` char(1) NOT NULL,
  `XCA_MOUSEPADDESCOUTROS` varchar(200) DEFAULT NULL,
  `XCA_MOUSEPADDETALHAMENTO` longtext,
  `XCA_MOUSEPADTAMANHO` varchar(50) DEFAULT NULL,
  `XCA_INGRESSOTIPO` varchar(50) DEFAULT NULL,
  `XCA_INGRESSODETALHAMENTO` longtext,
  `XCA_PULSEIRATIPO` varchar(50) DEFAULT NULL,
  `XCA_PULSEIRADETALHAMENTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ART_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCliente` (`EMP_ID`,`CLI_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoartealteracoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoartealteracoes` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `CAA_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAA_DATAPEDALTERACAO` datetime DEFAULT NULL,
  `USUARIO_REGISTROALTERACAO` varchar(30) DEFAULT '',
  `CAA_PRODUTO` varchar(15) DEFAULT '',
  `CAA_NOMECONTATO` varchar(30) DEFAULT '',
  `TIPOATENDIMENTO` varchar(30) DEFAULT '',
  `CAA_DETALHAMENTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ART_ID`,`CAA_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCriacaoArte` (`EMP_ID`,`ART_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoartearquivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoartearquivos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `ID_ARQUIVO` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `APROVADO` char(50) NOT NULL DEFAULT '',
  `DATA_APROVACAO` datetime DEFAULT NULL,
  `ENV_EMAIL` char(1) NOT NULL DEFAULT '',
  `ARQ_PRODUTO` varchar(15) DEFAULT '',
  `DESCRICAO` varchar(50) NOT NULL DEFAULT '',
  `LOCALIZACAOARQUIVO` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ART_ID`,`ID_ARQUIVO`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCriacaoArte` (`EMP_ID`,`ART_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoartecontatos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoartecontatos` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `CAC_ID` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `CAC_DATACONTATO` datetime DEFAULT NULL,
  `USUARIO_REGISTROCONTATO` varchar(30) DEFAULT '',
  `CAC_PRODUTO` varchar(15) DEFAULT '',
  `CAC_NOMECONTATO` varchar(30) DEFAULT '',
  `TIPOATENDIMENTO` varchar(30) DEFAULT '',
  `CAC_DETALHAMENTO` longtext,
  PRIMARY KEY (`EMP_ID`,`ART_ID`,`CAC_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCriacaoArte` (`EMP_ID`,`ART_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoartelogemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoartelogemail` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `ID_LOGEMAIL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATA_ENVIOEMAIL` datetime DEFAULT NULL,
  `EMAIL_ENVIOEMAIL` varchar(30) DEFAULT '',
  `USUARIO_ENVIOEMAIL` varchar(30) DEFAULT '',
  PRIMARY KEY (`EMP_ID`,`ART_ID`,`ID_LOGEMAIL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCriacaoArte` (`EMP_ID`,`ART_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xcriacaoartelogemailanexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xcriacaoartelogemailanexo` (
  `EMP_ID` int(11) NOT NULL DEFAULT '0',
  `ART_ID` int(11) NOT NULL DEFAULT '0',
  `ID_ARQUIVO` int(11) NOT NULL DEFAULT '0',
  `ID_LOGEMAIL` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`ART_ID`,`ID_ARQUIVO`,`ID_LOGEMAIL`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkCriacaoArte` (`EMP_ID`,`ART_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `fkCriacaoArteAquivo` (`EMP_ID`,`ART_ID`,`ID_ARQUIVO`),
  KEY `fkCriacaoArteLogEmail` (`EMP_ID`,`ART_ID`,`ID_LOGEMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xepedlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xepedlog` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `SEQUENCIAL` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `SERIENF` varchar(20) NOT NULL,
  `NUMERONF` int(11) NOT NULL,
  `DESCRICAOLOG` longtext NOT NULL,
  `STATUS` varchar(20) NOT NULL,
  `DATA` datetime NOT NULL,
  `CODIGOUSUARIO` int(11) NOT NULL,
  `NOMEARQUIVO` varchar(100) NOT NULL,
  `DATAHORAMODIFARQ` datetime NOT NULL,
  PRIMARY KEY (`SEQUENCIAL`,`EMP_ID`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `fkUsuario` (`CODIGOUSUARIO`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`),
  KEY `akStatusLog` (`EMP_ID`,`NOMEARQUIVO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xintegracaobosch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xintegracaobosch` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `NUMEROCONTROLE` int(10) unsigned NOT NULL,
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  `DATAGERACAO` datetime NOT NULL,
  `CODRECEPTORWING` varchar(20) NOT NULL,
  `CODRECPETORBOSCH` varchar(20) NOT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMEROCONTROLE`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xintegracaoboschnotas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xintegracaoboschnotas` (
  `EMP_ID` int(10) unsigned NOT NULL,
  `NUMEROCONTROLE` int(10) unsigned NOT NULL,
  `SERIENF` varchar(20) NOT NULL DEFAULT '',
  `NUMERONF` int(11) NOT NULL DEFAULT '0',
  `DATA_ALTERACAO` datetime DEFAULT NULL,
  `USER_ALTERACAO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`NUMEROCONTROLE`,`SERIENF`,`NUMERONF`),
  KEY `fkEmpresa` (`EMP_ID`),
  KEY `akTrigger1` (`EMP_ID`,`DATA_ALTERACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- insufficient privileges to SHOW CREATE FUNCTION `ObterValorCTEItem`
-- does _consulta have permissions on mysql.proc?

