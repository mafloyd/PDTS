CREATE TABLE [dbo].[Extract] (
    [EXTRACT_ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [NAME]                          VARCHAR (50)   NOT NULL,
    [COID]                          VARCHAR (5)    NOT NULL,
    [DATE_TRAP_PATTERN]             VARCHAR (50)   NOT NULL,
    [DATE_TRAP_BEGIN_COLUMN]        INT            NOT NULL,
    [DATE_TRAP_END_COLUMN]          INT            NOT NULL,
    [DETAIL_DATA_TRAP_PATTERN]      VARCHAR (1000) NOT NULL,
    [DETAIL_DATA_TRAP_BEGIN_COLUMN] INT            NOT NULL,
    [DETAIL_DATA_TRAP_END_COLUMN]   INT            NOT NULL,
    [CLASS_MODEL]                   VARCHAR (50)   NOT NULL,
    [COMPANY_IDENTIFIER]            NCHAR (10)     NULL,
    [DELIMITER]                     CHAR (1)       NULL,
    [DATE_TRAP_DELIMITED_COLUMN]    SMALLINT       CONSTRAINT [DF_Extract_DATE_TRAP_DELIMITED_COLUMN] DEFAULT ((0)) NOT NULL,
    [DATE_IN_DETAIL_DATA]           BIT            CONSTRAINT [DF_Extract_DATE_IN_DETAIL_DATA] DEFAULT ((0)) NOT NULL,
    [CHART_NUMBER]                  TINYINT        NOT NULL,
    [TWO_LINE_OUTPUT]               BIT            CONSTRAINT [DF_Extract_TWO_LINE_OUTPUT] DEFAULT ((0)) NOT NULL,
    [RANGE_OVERRIDE]                BIT            CONSTRAINT [DF_Extract_RANGE_OVERRIDE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Extract] PRIMARY KEY CLUSTERED ([EXTRACT_ID] ASC),
    CONSTRAINT [FK_Extract_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID])
);

