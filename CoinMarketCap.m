//
//  CoinMarketCap.m
//  Coins
//
//  Created by Alexander Ivanov on 18.12.2017.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "CoinMarketCap.h"

@implementation CoinMarketCap

__static(NSDictionary *, symbols, (@{ @"BTC" : @"Bitcoin",
									 @"ETH" : @"Ethereum",
									 @"LTC" : @"Litecoin",
									 @"XMR" : @"Monero",
									 @"USDT" : @"Tether",

									 @"DASH" : @"Dash",
									 @"GAS" : @"Gas",
									 @"XEM" : @"NEM",
									 @"XRP" : @"Ripple",
									 @"ZEC" : @"Zcash",

									 @"REP" : @"Augur",
									 @"GNO" : @"Gnosis-GNO",
									 @"OMG" : @"OmiseGO",
									 @"SC" : @"Siacoin",
									 @"STRAT" : @"Stratis",

									 @"ZRX" : @"0x",
									 @"ARDR" : @"Ardor",
									 @"STR" : @"Stellar",
									 @"LSK" : @"Lisk",
									 @"NAV" : @"NAV-Coin",

									 @"BCH" : @"Bitcoin-Cash",
									 @"BTCD" : @"BitcoinDark",
									 @"BTS" : @"BitShares",
									 @"DOGE" : @"Dogecoin",
									 @"GAME" : @"GameCredits",

									 @"BELA" : @"BelaCoin",
									 @"XBC" : @"Bitcoin-Plus",
									 @"BCY" : @"BitCrystals",
									 @"BTM" : @"Bitmark",
									 @"BLK" : @"BlackCoin",
									 @"BURST" : @"Burst",
									 @"BCN" : @"Bytecoin-BCN",
									 @"CVC" : @"Civic",
									 @"CLAM" : @"CLAMS",
									 @"XCP" : @"Counterparty",
									 @"DCR" : @"Decred",
									 @"DGB" : @"DigiByte",
									 @"EMC2" : @"Einsteinium",
									 @"ETC" : @"Ethereum-Classic",
									 @"EXP" : @"Expanse",
									 @"FCT" : @"Factom",
									 @"FLO" : @"Florincoin",
									 @"FLDC" : @"FoldingCoin",
									 @"GNT" : @"Golem",
									 @"GRC" : @"Gridcoin",
									 @"HUC" : @"Huntercoin",
									 @"LBC" : @"Library-Credit",
									 @"MAID" : @"MaidSafeCoin",
									 @"NMC" : @"Namecoin",
									 @"NEOS" : @"Neoscoin",
									 @"NXC" : @"Nexium",
									 @"NXT" : @"NXT",
									 @"OMNI" : @"Omni",
									 @"PASC" : @"Pascal-Coin",
									 @"PPC" : @"Peercoin",
									 @"PINK" : @"Pinkcoin",
									 @"POT" : @"PotCoin",
									 @"XPM" : @"Primecoin",
									 @"RADS" : @"Radium",
									 @"RIC" : @"Riecoin",
									 @"STEEM" : @"STEEM",
									 @"SBD" : @"Steem-Dollars",
									 @"STORJ" : @"Storj",
									 @"AMP" : @"Synereo",
									 @"SYS" : @"Syscoin",
									 @"XVC" : @"Vcash",
									 @"VRC" : @"VeriCoin",
									 @"VTC" : @"Vertcoin",
									 @"VIA" : @"Viacoin" }))

+ (NSURLSessionDataTask *)ticker:(NSString *)symbol handler:(void(^)(NSArray<NSDictionary *> *))handler {
	NSString *url = @"https://api.coinmarketcap.com/v1/ticker/";
	if (symbol)
		url = [url stringByAppendingString:[self symbols][symbol]];
	return [[NSURL URLWithString:url] sendRequestWithMethod:@"GET" header:Nil json:Nil completion:^(id json, NSURLResponse *response) {
		if (handler)
			handler(json);
	}];
}

+ (NSURLSessionDataTask *)global:(void(^)(NSDictionary *))handler {
	NSString *url = @"https://api.coinmarketcap.com/v1/global/";
	return [[NSURL URLWithString:url] sendRequestWithMethod:@"GET" header:Nil json:Nil completion:^(id json, NSURLResponse *response) {
		if (handler)
			handler(json);
	}];
}

@end
