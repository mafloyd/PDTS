CREATE TABLE [dbo].[ER_MONTHLY_DATA_STAGE] (
    [ER_DATA_STAGE_ID]        INT             IDENTITY (1, 1) NOT NULL,
    [COID]                    VARCHAR (5)     NOT NULL,
    [YEAR_OF_DISCHARGE_DATE]  INT             NOT NULL,
    [MONTH_OF_DISCHARGE_DATE] INT             NOT NULL,
    [FINANCIAL_CLASS_ID]      INT             NULL,
    [PAT_TYPE]                VARCHAR (5)     NOT NULL,
    [PAT_TYPE_POS1]           VARCHAR (1)     NOT NULL,
    [CHARGE_CPT_CODE]         VARCHAR (5)     NOT NULL,
    [CHARGE_REV_CODE]         INT             NOT NULL,
    [PAT_NUM]                 VARCHAR (50)    NOT NULL,
    [PAT_BIRTH_DATE]          DATETIME        NULL,
    [AGE]                     INT             NOT NULL,
    [ADMIT_TIME]              INT             NOT NULL,
    [NUMBER_OF_CASES]         INT             NOT NULL,
    [SUM_OF_TOTAL_CASH_PYMT]  DECIMAL (18, 2) NOT NULL,
    [SUM_OF_CHRG_AMT]         DECIMAL (18, 2) NOT NULL,
    [SUM_OF_CHRG_FACTORS]     INT             NOT NULL,
    [OBSERVATION]             BIT             CONSTRAINT [DF_ER_DATA_STAGE_OBSERVATION_1] DEFAULT ((0)) NOT NULL,
    [CHARGE_HCPCS_PROC]       VARCHAR (6)     NULL,
    CONSTRAINT [PK_ER_DATA_STAGE] PRIMARY KEY CLUSTERED ([ER_DATA_STAGE_ID] ASC)
);

