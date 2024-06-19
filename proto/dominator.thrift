include "proto/base.thrift"
include "proto/domain.thrift"

namespace java dev.vality.dominator
namespace erlang dominator.dominator

typedef string ContinuationToken

exception BadContinuationToken { 1: string reason }
exception LimitExceeded {}

struct CommonSearchQueryParams {
    1: optional list<string> currencies
    2: optional ContinuationToken continuation_token
    3: optional i32 limit
}

/* Набор параметров для поиска условий магазинов */
struct ShopSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional domain.PartyID party_id
    3: optional list<domain.ShopID> shop_ids
    4: optional list<string> term_sets_names
    5: optional list<domain.TermSetHierarchyRef> term_sets_ids
}

/* Набор параметров для поиска условий кошельков */
struct WalletSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional domain.PartyID party_id
    3: optional list<domain.IdentityProviderRef> identity_ids
    4: optional list<domain.WalletID> wallet_ids
    5: optional list<string> term_sets_names
    6: optional list<domain.TermSetHierarchyRef> term_sets_ids
}

/* Набор параметров для поиска условий терминалов */
struct TerminalSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional list<domain.ProviderRef> provider_ids
    3: optional list<domain.TerminalRef> terminal_ids
}

/* Набор условий для магазина */
struct ShopTermSet {
    1: required domain.PartyID owner_id
    2: optional domain.ShopID shop_id
    3: required domain.ContractID contract_id
    4: required string shop_name
    5: required string term_set_name
    6: required string currency
    7: required domain.TermSetHierarchyObject current_term_set
    8: optional list<TermSetHistory> term_set_history
}

/* Набор условий для кошелька */
struct WalletTermSet {
    1: required domain.PartyID owner_id
    2: optional domain.IdentityProviderRef identity_id
    3: required domain.ContractID contract_id
    4: required domain.WalletID wallet_id
    5: required string wallet_name
    6: required string term_set_name
    7: required string currency
    8: required domain.TermSetHierarchyObject current_term_set
    9: optional list<TermSetHistory> term_set_history
}

struct TermSetHistory {
    1: required domain.TermSetHierarchyObject term_set
    2: optional string applied_at
}

/* Набор условий для терминала */
struct TerminalTermSet {
    1: required domain.TerminalRef terminal_id
    2: required string terminal_name
    3: required domain.ProviderRef provider_id
    4: required string provider_name
    5: required list<string> currencies
    6: required domain.ProvisionTermSet current_term_set
    7: optional list<ProvisionTermSetHistory> term_set_history
}

struct ProvisionTermSetHistory {
    1: required domain.ProvisionTermSet term_set
    2: optional string applied_at
}

struct ShopTermSetsResponse {
    1: required list<ShopTermSet> terms
    2: optional string continuation_token
}

struct WalletTermSetsResponse {
    1: required list<WalletTermSet> terms
    2: optional string continuation_token
}

struct TerminalTermSetsResponse {
    1: required list<TerminalTermSet> terms
    2: optional string continuation_token
}

service DominatorService {

    /* Поиск условий для магаизнов */
    ShopTermSetsResponse SearchShopTermSets (1: ShopSearchQuery shop_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    /* Поиск условий для кошельков */
    WalletTermSetsResponse SearchWalletTermSets (1: WalletSearchQuery wallet_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    /* Поиск условий для терминалов */
    TerminalTermSetsResponse SearchTerminalTermSets (1: TerminalSearchQuery terminal_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)
}