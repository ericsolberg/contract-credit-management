sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'contract.management.ui.contracts',
            componentId: 'ValueContractsObjectPage',
            contextPath: '/ValueContracts'
        },
        CustomPageDefinitions
    );
});