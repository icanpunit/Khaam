//
//  ConstantURL.swift
//  FoodBook
//
//  Created by Mandip Kanjiya on 26/07/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import Foundation

let kbaseURL = "http://www.khaam.me/admin/webservices/"//"http://157.175.67.176/webservices/"
let kbaseImageURL = "http://54.93.252.80/ViteEcommerce" //"http://54.93.252.80/tahanifloweradmin/"
let kbasePayment = "http://54.93.252.80/ViteEcommerce/knetpayment/checkout.aspx"
let KbasecToken = "qxWOVJ26A6xezTscJKIj"

//MARK:- Webservice API list

    //MARK:- Signup

    let kSignup                         = kbaseURL + "customer.asmx/AddCustomer"

    //MARK:- Login

    let kLogin                          = kbaseURL + "login.asmx/LogIn_User"

    //MARK:- Home

    let kUserDetails                    = kbaseURL + "customer.asmx/SelectRow"
    let kAllBanner                      = kbaseURL + "slider.asmx/SelectAllSliderV2"
    let kCategoryList                   = kbaseURL + "category.asmx/SelectAllCategoryByLanguageId"
    let kCategoryListHome                   = kbaseURL + "product.asmx/SelectHomeCategoryAndProduct"
    let kGetFeelItMostSellerProductWithCategory                   = kbaseURL + "Product.asmx/GetFeelItMostSellerProductWithCategory"

//"category.asmx/SelectAllCategoryByLanguageId"
    let kFeatureProducts                = kbaseURL + "product.asmx/SelectAllFeatureProduct"

    //MARK:- Forgot Password

    let kForgotPassword                 = kbaseURL + "login.asmx/ForgotPassword"

    //MARK:- Get Product By Category

    let kProductByCategory              = kbaseURL + "Product.asmx/SelectProductListBySmartFilter"
    let kSelectAllVendorProduct              = kbaseURL + "product.asmx/SelectAllVendorProduct"
    let kGetFeelItMostSellerProduct             = kbaseURL + "Product.asmx/GetFeelItMostSellerProduct"
    //MARK:- Product Details

    let kProductDetials                 = kbaseURL + "product.asmx/Select_Product_DetailsV2"
    let kCreateCart                     = kbaseURL + "cart.asmx/CreateCart"
    let kSelectAllCartProductByCustomer = kbaseURL + "cart.asmx/SelectAllCartProductByCustomerV2"
    let kGetCartAndAllData              = kbaseURL + "cart.asmx/GetCartAndAllDataV1"
    let kDeleteCartRecord               = kbaseURL + "cart.asmx/DeleteCartRecord"
    let kDeleteBooking               = kbaseURL + "Booking.asmx/DeleteBooking"
    // MARK:- Product Category

    let kProductCategory                = kbaseURL + "product.asmx/Select_Product_Details"

    // MARK: - Search Product

    let kSearchProduct                  = kbaseURL + "product.asmx/SelectSearchProductV1"

    // MARK:- Update Prodfile

    let kUpdateProfile                  = kbaseURL + "customer.asmx/UpdateCustomerProfile"
    let kUploadFile                     = kbaseURL + "fileupload.asmx/uploadfile"

    // MARK:- Get Sub Category

    let kSubCategory                    = kbaseURL + "category.asmx/SelectAllSubCategoryByparentId"
    let kGetVendorProductWiseCategoryList                   = kbaseURL + "category.asmx/GetVendorProductWiseCategoryList"

    // MARK:- Get All Language

    let kLanguages                       = kbaseURL + "language.asmx/SelectAllLanguage"

    // MARK:- Reset Password

    let kResetPassword                   = kbaseURL + "login.asmx/ChangePassword"

    // MARK:- Address

    let kAddNewAddress                   = kbaseURL + "address.asmx/AddAddressV2"
    let kAllAddress                      = kbaseURL + "address.asmx/SelectAllAddressByCustomer"
    let kGetAddressDetail                = kbaseURL + "address.asmx/SelectAddressDetail"
    let kUpdateAddress                   = kbaseURL + "address.asmx/UpdateAddressV2"
    let kDeleteAddress                   = kbaseURL + "address.asmx/DeleteAddress"

    // MARK:- Contact us

    let kContactUs                       = kbaseURL + "customer.asmx/SendContactUsMail"
    let kContactAbout                       = kbaseURL + "customer.asmx/SelectContentByPageName"
    let kSelectCMSPagesDetails                       = kbaseURL + "CMSPage.asmx/SelectCMSPagesDetails"

    // MARK: - Order

    let kPlaceOrder                      = kbaseURL + "order.asmx/CreateOrderWithJsonDataV3"
    let kGetOrders                       = kbaseURL + "order.asmx/SelectAllOrderByCustomerWise"
    let kGetOrderDetails                 = kbaseURL + "order.asmx/SelectRowOrder"
    let kCouponCode                      = kbaseURL + "offer.asmx/CheckCouponCodeNew"
    let kTimeBookings                    = kbaseURL + "Booking.asmx/GetBookingTimeSlotV1"
    let kTimeSlots                       = kbaseURL + "Deliverytime.asmx/GetTimeSlot"
    let kUpdateOrderStatusCustomer       = kbaseURL + "order.asmx/UpdateOrderStatusCustomer"
    let kSelectAllCountryByLanguageId    = kbaseURL + "Country.asmx/SelectAllCountryByLanguageId"
    let kSelectAllCityByLanguageIdAndCountryId    = kbaseURL + "Country.asmx/SelectAllCityByLanguageIdAndCountryId"
    let kSelectAllAreaByLanguageIdAndCityId    = kbaseURL + "Country.asmx/SelectAllAreaByLanguageIdAndCityId"
 
    // MARK: - Add wishlist
    let kInsertData                      = kbaseURL + "Wishlist.asmx/InsertData"
    let kSelectAllWishlistProduct                      = kbaseURL + "product.asmx/SelectAllWishlistProduct"
    let kgetguestuserdetails             = kbaseURL + "login.asmx/getguestuserdetails"
    let kSelectAllSupplier               = kbaseURL + "customer.asmx/SelectAllSupplier"
    let kCartCountbyCustomer             = kbaseURL + "cart.asmx/CartCountbyCustomer"
    let kSelectAllNotification           = kbaseURL + "notificationData.asmx/SelectAllNotification"
    let kUpdateNotificationIsSeen          = kbaseURL + "notificationData.asmx/UpdateNotificationIsSeen"
    let kUpdatePaymentStatusv2          = kbaseURL + "order.asmx/UpdatePaymentStatusV2"
 let kUpdatePaymentStatus         = kbaseURL + "Booking.asmx/UpdatePaymentStatus"
    let kSelectSmartFilterByAttributeJsonData          = kbaseURL + "Product.asmx/SelectSmartFilterByAttributeJsonDataV2"
    let kSelectCustomerWalletDetail          = kbaseURL + "CustomerWallet.asmx/SelectCustomerWalletDetail"
    let kSampleOrderReturn          = kbaseURL + "Order.asmx/SampleOrderReturn"
    let kAddBooking               = kbaseURL + "Booking.asmx/AddBookingV1"
 let kGetBookingDetails          = kbaseURL + "Booking.asmx/GetBookingDetails"


