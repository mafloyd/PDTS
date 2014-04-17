CREATE TABLE [dbo].[OperationalInitiative] (
    [OPERATIONAL_INITIATIVE_ID]        INT             IDENTITY (1, 1) NOT NULL,
    [COID]                             VARCHAR (5)     NOT NULL,
    [INITIATIVE]                       VARCHAR (1000)  NOT NULL,
    [OPERATIONAL_CATEGORY_ID]          INT             NOT NULL,
    [OWNER]                            VARCHAR (50)    NOT NULL,
    [START_DATE]                       DATETIME        NULL,
    [ESTIMATED_COMPLETION_DATE]        DATETIME        NULL,
    [PROJECTED_FINANCIAL_IMPACT]       DECIMAL (19, 2) NULL,
    [MTD_ACTUAL]                       DECIMAL (19, 2) NULL,
    [YTD_ACTUAL]                       DECIMAL (19, 2) NULL,
    [CREATE_DATE]                      DATETIME        CONSTRAINT [DF_OperationalInitiative_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]               INT             NOT NULL,
    [UPDATE_DATE]                      DATETIME        NULL,
    [UPDATED_BY_USER_ID]               INT             NULL,
    [OPERATIONAL_INITIATIVE_STATUS_ID] INT             NULL,
    CONSTRAINT [PK_OperationalInitiative] PRIMARY KEY CLUSTERED ([OPERATIONAL_INITIATIVE_ID] ASC),
    CONSTRAINT [FK_OperationalInitiative_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OperationalInitiative_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_OperationalInitiative_OperationalCategory] FOREIGN KEY ([OPERATIONAL_CATEGORY_ID]) REFERENCES [dbo].[OperationalCategory] ([OPERATIONAL_CATEGORY_ID]),
    CONSTRAINT [FK_OperationalInitiative_OperationalInitiativeStatus] FOREIGN KEY ([OPERATIONAL_INITIATIVE_STATUS_ID]) REFERENCES [dbo].[OperationalInitiativeStatus] ([OPERATIONAL_INITIATIVE_STATUS_ID]),
    CONSTRAINT [FK_OperationalInitiative_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

