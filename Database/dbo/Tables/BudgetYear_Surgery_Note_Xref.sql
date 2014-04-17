CREATE TABLE [dbo].[BudgetYear_Surgery_Note_Xref] (
    [BUDGETYEAR_SURGERY_NOTE_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]                INT NOT NULL,
    [NOTE_ID]                         INT NOT NULL,
    [BUDGETYEAR_SURGERY_ID]           INT NOT NULL,
    CONSTRAINT [PK_BudgetYear_Surgery_Note_Xref] PRIMARY KEY CLUSTERED ([BUDGETYEAR_SURGERY_NOTE_XREF_ID] ASC),
    CONSTRAINT [FK_BudgetYear_Surgery_Note_Xref_BudgetYear_Surgery] FOREIGN KEY ([BUDGETYEAR_SURGERY_ID]) REFERENCES [dbo].[BudgetYear_Surgery] ([BUDGETYEAR_SURGERY_ID]),
    CONSTRAINT [FK_BudgetYear_Surgery_Note_Xref_Note] FOREIGN KEY ([NOTE_ID]) REFERENCES [dbo].[Note] ([NOTE_ID]),
    CONSTRAINT [FK_BudgetYear_Surgery_Note_Xref_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

