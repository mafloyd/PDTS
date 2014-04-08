CREATE TABLE [dbo].[tblLPNTGLMasterAccts] (
    [LPNTACCTID]     INT           IDENTITY (1, 1) NOT NULL,
    [LPNTFSCode]     VARCHAR (50)  NULL,
    [LPNTFSCodeDesc] VARCHAR (75)  NULL,
    [LPNTAcct]       VARCHAR (50)  NOT NULL,
    [LPNTAcctDesc]   VARCHAR (100) NULL,
    CONSTRAINT [PK_tblLPNTGLMasterAccts] PRIMARY KEY CLUSTERED ([LPNTAcct] ASC)
);

