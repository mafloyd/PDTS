﻿CREATE TABLE [dbo].[ER_PAYMENT_TOTALS] (
    [ER_PAYMENT_TOTAL_ID] INT         IDENTITY (1, 1) NOT NULL,
    [COID]                VARCHAR (5) NOT NULL,
    [PERIOD_BEGIN_DATE]   DATETIME    NOT NULL,
    [PERIOD_END_DATE]     DATETIME    NOT NULL,
    [TOTAL_PAYMENTS]      MONEY       NOT NULL,
    CONSTRAINT [PK_ER_AVERAGE_PAYMENT_RATE] PRIMARY KEY CLUSTERED ([ER_PAYMENT_TOTAL_ID] ASC)
);

