CREATE TABLE [dbo].[ig_AR_RiskStatus_Definition] (
    [AR_RISK_ID]      INT           IDENTITY (1, 1) NOT NULL,
    [IGRISKSTATUS_ID] INT           NOT NULL,
    [RISK_DEFINITION] VARCHAR (500) NOT NULL,
    CONSTRAINT [PK_ig_AR_RiskStatus_Definition] PRIMARY KEY CLUSTERED ([AR_RISK_ID] ASC),
    CONSTRAINT [FK_ig_AR_RiskStatus_Definition_ig_RiskStatus] FOREIGN KEY ([IGRISKSTATUS_ID]) REFERENCES [dbo].[ig_RiskStatus] ([IGRISKSTATUS_ID])
);

