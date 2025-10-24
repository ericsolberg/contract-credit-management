sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"contract/management/ui/contracts/test/integration/pages/ValueContractsList",
	"contract/management/ui/contracts/test/integration/pages/ValueContractsObjectPage"
], function (JourneyRunner, ValueContractsList, ValueContractsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('contract/management/ui/contracts') + '/test/flpSandbox.html#contractmanagementuicontracts-tile',
        pages: {
			onTheValueContractsList: ValueContractsList,
			onTheValueContractsObjectPage: ValueContractsObjectPage
        },
        async: true
    });

    return runner;
});

