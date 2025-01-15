create table Delivery_Note(
	DN_id char(5) primary key,
    DN_export_date date not null,
    DN_total_amount float,
    DN_status tinyint
);

create table Supplies(
	Sup_id char(5) primary key,
    Sup_name varchar(100) not null unique,
    Sup_status bit default(1)
);

create table Detailed_Delivery_Note(
	DN_id char(5),
    constraint FK1_DN_id foreign key (DN_id) references Delivery_Note(DN_id),
    Sup_id char(5),
    constraint FK2_Sup_id foreign key (Sup_id) references Supplies(Sup_id),
    DDN_export_unit_price float check (DDN_export_unit_price > 0),
    DDN_export_quantity int not null,
    primary key (DN_id, Sup_id)
);

create table Receipt_Note(
	RN_id char(5) primary key,
    RN_import_date date not null,
    RN_created date not null,
    RN_total_amount float,
    RN_status tinyint
);

create table Vendor(
	Ven_id char(5) primary key,
    Ven_name varchar(100) not null unique,
    Ven_address text not null,
    Ven_phone char(10) not null,
    Ven_email varchar(100) not null,
    Ven_status bit default(1)
);

create table Purchase_Order(
	PO_id int auto_increment primary key,
    PO_order_date date not null,
    Ven_id char(5) not null,
    constraint FK_Ven_id foreign key (Ven_id) references Vendor(Ven_id),
    PO_status tinyint
);

create table Purchase_Order_Detail(
	Sup_id char(5),
    constraint FK1_Sup_id foreign key (Sup_id) references Supplies(Sup_id),
    PO_id int,
    constraint FK2_PO_id foreign key (PO_id) references Purchase_Order(PO_id),
    primary key (Sup_id, PO_id)
);

create table Detailed_Receipt_Note(
	RN_id char(5),
    constraint FK_RN_id foreign key (RN_id) references Receipt_Note(RN_id),
    Sup_id char(5),
    constraint FK_Sup_id foreign key (Sup_id) references Supplies(Sup_id),
    primary key (RN_id, Sup_id),
    DRN_import_unit_price float check (DRN_import_unit_price > 0),
    DRN_import_quantity int not null
);



