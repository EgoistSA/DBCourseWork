CREATE DATABASE  IF NOT EXISTS `bookshop` ;
USE `bookshop`;


-- 创建书籍表(Books)
CREATE TABLE Books (
                       BookID INT PRIMARY KEY,
                       SeriesNO INT,
                       Title VARCHAR(255) NOT NULL,
                       ISBN VARCHAR(255) NOT NULL,
                       Authors VARCHAR(255),
                       Publisher VARCHAR(255),
                       SalePrice INT NOT NULL,
                       PreviousID INT,
                       NextID INT,
                       SupplierID VARCHAR(255),
                       TagNumber INT DEFAULT 0,
                       CoverImage VARCHAR(255),
                       StockQuantity INT DEFAULT 0,
                       StorageLocation VARCHAR(255),
                       UpdateDate DATETIME,
                       CreateDate DATETIME
);

-- 创建库存表(Stock)
CREATE TABLE Stock (
                       StockID INT PRIMARY KEY,
                       BookID INT,
                       StorageLocation VARCHAR(255),
                       StockQuantity INT NOT NULL,
                       FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- 创建供应商表(Suppliers)
CREATE TABLE Suppliers (
                           SupplierID INT PRIMARY KEY,
                           SupplierName VARCHAR(255) NOT NULL,
                           ContactInfo VARCHAR(255),
                           TradeAmount INT,
                           ProvidedBooks TEXT
);

-- 创建用户表(Users)
CREATE TABLE Users (
                       UserID INT PRIMARY KEY,
                       LoginID VARCHAR(255) UNIQUE NOT NULL,
                       Password VARCHAR(255) NOT NULL,
                       Name VARCHAR(255),
                       Address VARCHAR(255),
                       AccountBalance INT DEFAULT 0,
                       Status ENUM('游客', '客户', '管理员') DEFAULT '游客',
                       CreditLevel INT DEFAULT 1,
                       Email VARCHAR(255),
                       UpdateTime DATETIME,
                       CreateTime DATETIME
);

-- 创建订单表(Orders)
CREATE TABLE Orders (
                        OrderID INT PRIMARY KEY,
                        OrderDate DATETIME NOT NULL,
                        BookID INT,
                        Status ENUM('预定', '付款', '到货', '完成', '退款') DEFAULT '预定',
                        Quantity INT NOT NULL,
                        Price INT NOT NULL,
                        UserID INT,
                        TotalAmount INT,
                        ShippingAddress VARCHAR(255) NOT NULL,
                        FOREIGN KEY (BookID) REFERENCES Books(BookID),
                        FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 创建标签表(Tags)
CREATE TABLE Tags (
                      TagID INT PRIMARY KEY,
                      Tag VARCHAR(255),
                      Status ENUM('隐藏', '正常') DEFAULT '隐藏'
);

-- 创建书籍标签表(BookTags)
CREATE TABLE BookTags (
                          BookID INT,
                          TagID INT,
                          Status ENUM('HIDE','COMMON') DEFAULT 'HIDE',
                          FOREIGN KEY (BookID) REFERENCES Books(BookID),
                          FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

-- 创建缺书记录表(OutOfStockRecords)
CREATE TABLE OutOfStockRecords (
                                   RecordID INT PRIMARY KEY,
                                   BookID INT,
                                   Quantity INT NOT NULL,
                                   RequestDate DATETIME NOT NULL,
                                   Status ENUM('提交', '确认', '撤回', '完成') DEFAULT '提交',
                                   UserID INT,
                                   SupplierID INT,
                                   FOREIGN KEY (BookID) REFERENCES Books(BookID),
                                   FOREIGN KEY (UserID) REFERENCES Users(UserID),
                                   FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 创建采购单表(PurchaseOrders)
CREATE TABLE PurchaseOrders (
                                PurchaseOrderID INT PRIMARY KEY,
                                RecordID INT,
                                SupplierID INT,
                                Status ENUM('预备', '定金', '到货', '尾款', '交易完成') DEFAULT '预备',
                                Price INT,
                                PurchaseDate DATETIME NOT NULL,
                                ArrivalStatus VARCHAR(50) DEFAULT 'Pending',
                                FOREIGN KEY (RecordID) REFERENCES OutOfStockRecords(RecordID),
                                FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 创建信用等级表(CreditRules)
CREATE TABLE CreditRules (
                             CreditLevel INT PRIMARY KEY,
                             DiscountRate INT NOT NULL,
                             OverdraftLimit INT DEFAULT 0,
                             PrepayRequired BOOLEAN NOT NULL
);