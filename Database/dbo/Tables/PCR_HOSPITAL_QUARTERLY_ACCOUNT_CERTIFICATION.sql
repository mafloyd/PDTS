﻿CREATE TABLE [dbo].[PCR_HOSPITAL_QUARTERLY_ACCOUNT_CERTIFICATION] (
    [PCR_HOSPITAL_QUARTERLY_ACCOUNT_CERTIFICATION] INT          IDENTITY (1, 1) NOT NULL,
    [COID]                                         VARCHAR (5)  NOT NULL,
    [QUARTER]                                      TINYINT      NOT NULL,
    [YEAR]                                         INT          NOT NULL,
    [IS_PRE]                                       BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_IS_PRE] DEFAULT ((0)) NOT NULL,
    [IS_POST]                                      BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_IS_POST] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]                                  DATETIME     CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CONTROLLER_CERTIFIED]                         BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_CONTROLLER_CERTIFIED] DEFAULT ((0)) NOT NULL,
    [CONTROLLER]                                   VARCHAR (50) NULL,
    [CONTROLLER_CERT_DATE]                         DATETIME     NULL,
    [CFO_CERTIFIED]                                BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_CFO_CERTIFIED] DEFAULT ((0)) NOT NULL,
    [CFO]                                          VARCHAR (50) NULL,
    [CFO_CERT_DATE]                                DATETIME     NULL,
    [CEO_CERTIFIED]                                BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_CEO_CERTIFIED] DEFAULT ((0)) NOT NULL,
    [CEO]                                          VARCHAR (50) NULL,
    [CEO_CERT_DATE]                                DATETIME     NULL,
    [DIVISION_CONTROLLER_CERTIFIED]                BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_DIVISION_CONTROLLER_CERTIFIED] DEFAULT ((0)) NOT NULL,
    [DIVISION_CONTROLLER]                          VARCHAR (50) NULL,
    [DIVISION_CONTROLLER_CERT_DATE]                DATETIME     NULL,
    [IS_OTHER_COIDS]                               BIT          CONSTRAINT [DF_PCR_HOSPITAL_QUARTERLY_ACCOUNT_CERTIFICATION_IS_OTHER_COIDS] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION] PRIMARY KEY CLUSTERED ([PCR_HOSPITAL_QUARTERLY_ACCOUNT_CERTIFICATION] ASC),
    CONSTRAINT [FK_PCR_HOSPITAL_QUARTERLY_ACCONT_CERTIFICATION_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID])
);

