CREATE TABLE [dbo].[FacilityCapital] (
    [FACILITY_CAPTIAL_ID]     INT             IDENTITY (1, 1) NOT NULL,
    [COID]                    VARCHAR (5)     NOT NULL,
    [BUDGET_YEAR]             INT             NOT NULL,
    [BUDGETED_CAPITAL_AMOUNT] DECIMAL (10, 2) NOT NULL,
    [CREATE_DATE]             DATETIME        CONSTRAINT [DF_FacilityCapital_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]      INT             NOT NULL,
    [UPDATE_DATE]             DATETIME        NULL,
    [UPDATED_BY_USER_ID]      INT             NULL,
    CONSTRAINT [PK_FacilityCapital] PRIMARY KEY CLUSTERED ([FACILITY_CAPTIAL_ID] ASC),
    CONSTRAINT [FK_FacilityCapital_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_FacilityCapital_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_FacilityCapital_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

