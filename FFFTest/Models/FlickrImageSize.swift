//
//  FlickrImageSize.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//
//https://www.flickr.com/services/api/misc.urls.html

enum FlickrImageSize : String {
    case smallSquare75 = "s"           // s	small square 75x75
    case largeSquare150 = "q"          // q	large square 150x150
    case minuatureLongerSide100 = "t"  // t	miniature, 100 on longest side
    case smallLongerSide240 = "m"      // m	pequeno, 240 on longest side
    case largeLongerSide320 = "n"      // n	small, 320 on longest side
    case mediumLongerSide500 = "-"     // -	medium, 500 on longest side
    case mediumLongerSide640 = "z"     // z	medium 640, 640 on longest side
    case mediumLongerSide800 = "c"     // c	medium 800, 800 on longest side
    case largeLongerSide1024 = "b"     // b	big, 1024 on longest side*
    case largeLongerSide1600 = "h"     // h	big 1600, 1600 on longest side
    case largeLongerSide2048 = "k"     // k	big 2048, 2048 on longest side
    case original = "o"                // o	original image, jpg, gif or png, depending on origin format
    
}
