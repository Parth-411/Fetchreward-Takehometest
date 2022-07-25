CREATE TABLE `Receipts` (
  `receiptId` varchar(255) PRIMARY KEY,
  `bonusPointsEarned` float,
  `bonusPointsEarnedReason` varchar(255),
  `createDate` timestamp,
  `dateScanned` timestamp,
  `finishedDate` timestamp,
  `modifyDate` timestamp,
  `pointsAwardedDate` timestamp,
  `pointsEarned` int,
  `purchaseDate` timestamp,
  `purchasedItemCount` int,
  `rewardsReceiptStatus` varchar(255),
  `totalSpent` float,
  `userId` varchar(255)
);

CREATE TABLE `Items` (
  `receiptId` varchar(255),
  `dateScanned` timestamp,
  `barcode` int,
  `brandCode` varchar(255),
  `description` varchar(255),
  `item_price` float,
  `partnerItemId` int,
  `userId` varchar(255)
);

CREATE TABLE `Brands` (
  `brandId` varchar(255) PRIMARY KEY,
  `brandCode` varchar(255),
  `barcode` int,
  `category` varchar(255),
  `categoryCode` varchar(255),
  `name` varchar(255),
  `topBrand` boolean,
  `cpg_Id` varchar(255),
  `cpf_Ref` varchar(255)
);

CREATE TABLE `Users` (
  `userId` varchar(255) PRIMARY KEY,
  `active` boolean,
  `createdDate` timestamp,
  `lastLogin` timestamp,
  `role` varchar(255),
  `signUpSource` varchar(255),
  `state` varchar(255)
);

ALTER TABLE `Receipts` ADD FOREIGN KEY (`userId`) REFERENCES `Users` (`userId`);

ALTER TABLE `Items` ADD FOREIGN KEY (`userId`) REFERENCES `Users` (`userId`);

ALTER TABLE `Items` ADD FOREIGN KEY (`receiptId`) REFERENCES `Receipts` (`receiptId`);

ALTER TABLE `Items` ADD FOREIGN KEY (`brandCode`) REFERENCES `Brands` (`brandCode`);
