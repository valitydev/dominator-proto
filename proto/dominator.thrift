include "proto/base.thrift"
include "proto/domain.thrift"

namespace java com.empayre.dominator
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
struct ShopsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required domain.PartyID party_id
    3: optional list<domain.ShopID> shop_ids
    4: optional list<string> term_sets_names
}

/* Набор параметров для поиска условий кошельков */
struct WalletsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required domain.PartyID party_id
    3: optional list<base.ID> identity_ids
    4: optional list<string> term_sets_names
}

/* Набор параметров для поиска условий терминалов */
struct TerminalsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional list<base.ID> provider_ids
    3: optional list<base.ID> terminal_ids
}

/* Набор условий для магазина/кошелька */
struct TermSet {
    1: required domain.PartyID owner_id
    2: optional domain.ShopID shop_id
    3: optional domain.IdentityProviderRef identity_id
    4: required domain.ContractID contract_id
    5: required string shop_name
    6: required string term_set_name
    7: required domain.TermSetHierarchyObject current_term_set
    8: optional list<domain.TermSetHierarchyObject> term_set_history
}

/* Набор условий для терминала */
struct TerminalTermSet {
    1: required domain.TerminalRef terminal_id
    2: required string terminal_name
    3: required string provider
    4: required domain.ProvisionTermSet current_term_set
    5: optional list<domain.ProvisionTermSet> term_set_history
}

struct TermSetsResponse {
    1: required list<TermSet> terms
    2: optional string continuation_token
}

struct TerminalTermSetsResponse {
    1: required list<TerminalTermSet> terms
    2: optional string continuation_token
}

service DominatorService {

    /* Поиск условий для магаизнов */
    TermSetsResponse SearchShopTermSets (1: ShopsSearchQuery shops_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    /* Поиск условий для кошельков */
    TermSetsResponse SearchWalletTermSets (1: WalletsSearchQuery wallets_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)

    /* Поиск условий для терминалов */
    TerminalTermSetsResponse SearchTerminalTermSets (1: TerminalsSearchQuery terminals_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)
}