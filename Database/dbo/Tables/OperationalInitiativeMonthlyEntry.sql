CREATE TABLE [dbo].[OperationalInitiativeMonthlyEntry] (
    [OPERATIONAL_INITIATIVE_MONTHLY_ENTRY_ID] INT             IDENTITY (1, 1) NOT NULL,
    [OPERATIONAL_INITIATIVE_ID]               INT             NOT NULL,
    [MONTHLY_AMOUNT]                          DECIMAL (19, 2) NOT NULL,
    [COMMENT]                                 VARCHAR (1000)  NOT NULL,
    [CREATE_DATE]                             DATETIME        CONSTRAINT [DF_OperationalInitiativeMonthlyEntry_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                      INT             NOT NULL,
    [UPDATE_DATE]                             DATETIME        NULL,
    [UPDATED_BY_USER_ID]                      INT             NULL,
    [REPORTING_PERIOD_MONTH]                  INT             NOT NULL,
    [REPORTING_PERIOD_YEAR]                   INT             NOT NULL,
    [REPORTING_PERIOD]                        DATETIME        NOT NULL,
    CONSTRAINT [PK_OperationalInitiativeMonthlyEntry] PRIMARY KEY CLUSTERED ([OPERATIONAL_INITIATIVE_MONTHLY_ENTRY_ID] ASC),
    CONSTRAINT [FK_OperationalInitiativeMonthlyEntry_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OperationalInitiativeMonthlyEntry_OperationalInitiative] FOREIGN KEY ([OPERATIONAL_INITIATIVE_ID]) REFERENCES [dbo].[OperationalInitiative] ([OPERATIONAL_INITIATIVE_ID]),
    CONSTRAINT [FK_OperationalInitiativeMonthlyEntry_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

