CREATE TABLE [dbo].[ig_Worksheet_CashRcpts_Note_Xref] (
    [IG_WORKSHEET_CASH_RECPT_NOTE_XREF_ID] INT      IDENTITY (1, 1) NOT NULL,
    [RECEIPT_ID]                           INT      NOT NULL,
    [WS_NOTE_ID]                           INT      NOT NULL,
    [CREATE_DATE]                          DATETIME CONSTRAINT [DF_ig_Worksheet_CashRcpts_Note_Xref_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                   INT      NOT NULL,
    CONSTRAINT [PK_ig_Worksheet_CashRcpts_Note_Xref] PRIMARY KEY CLUSTERED ([IG_WORKSHEET_CASH_RECPT_NOTE_XREF_ID] ASC),
    CONSTRAINT [FK_ig_Worksheet_CashRcpts_Note_Xref_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ig_Worksheet_CashRcpts_Note_Xref_ig_Worksheet_CashRcpts] FOREIGN KEY ([RECEIPT_ID]) REFERENCES [dbo].[ig_Worksheet_CashRcpts] ([RECEIPT_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ig_Worksheet_CashRcpts_Note_Xref_ig_Worksheet_Notes] FOREIGN KEY ([WS_NOTE_ID]) REFERENCES [dbo].[ig_Worksheet_Notes] ([WS_NOTE_ID])
);

