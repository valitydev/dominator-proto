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

struct ShopsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required domain.PartyID party_id
    3: optional list<domain.ShopID> shop_ids
    4: optional list<string> term_names
}

struct WalletsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: required domain.PartyID party_id
    3: optional list<base.ID> identity_ids
    4: optional list<string> term_names
}

struct TerminalsSearchQuery {
    1: required CommonSearchQueryParams common_search_query_params
    2: optional list<base.ID> provider_ids
    3: optional list<base.ID> terminal_ids
}

struct Term {
    1: required domain.PartyID owner_id
    2: optional domain.ShopID shop_id
    3: optional domain.IdentityProviderRef identity_id
    4: required domain.ContractID contract_id
    5: required string shop_name
    6: required string term_name
    7: required domain.TermSetHierarchyObject current_term
    8: optional list<domain.TermSetHierarchyObject> term_history
}

struct TerminalTerm {
    1: required domain.TerminalRef terminal_id
    2: required string terminal_name
    3: required string provider
    4: required domain.ProvisionTermSet current_term
    5: optional list<domain.ProvisionTermSet> term_history
}

struct TermsResponse {
    1: required list<Term> terms
    2: optional string continuation_token
}

struct TerminalTermsResponse {
    1: required list<TerminalTerm> terms
    2: optional string continuation_token
}

service DominatorService {

    TermsResponse SearchShopTerms (1: ShopsSearchQuery shops_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)


    TermsResponse SearchWalletTerms (1: WalletsSearchQuery wallets_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)


    TerminalTermsResponse SearchTerminalTerms (1: TerminalsSearchQuery terminals_search_query)
        throws (1: BadContinuationToken ex1, 2: LimitExceeded ex2, 3: base.InvalidRequest ex3)
}