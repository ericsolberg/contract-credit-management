sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"contract/management/ui/customers/test/integration/pages/CustomersList",
	"contract/management/ui/customers/test/integration/pages/CustomersObjectPage"
], function (JourneyRunner, CustomersList, CustomersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('contract/management/ui/customers') + '/test/flpSandbox.html#contractmanagementuicustomers-tile',
        pages: {
			onTheCustomersList: CustomersList,
			onTheCustomersObjectPage: CustomersObjectPage
        },
        async: true
    });

    return runner;
});

