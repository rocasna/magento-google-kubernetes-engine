<?php
return [
    'MAGE_MODE' => 'production',
    'backend' => ['frontName' => 'admin'],
    'crypt' => ['key' => 'build_placeholder_not_used_in_runtime'],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => 'localhost',
                'dbname' => 'magento',
                'username' => 'magento',
                'password' => 'magento',
                'active' => '1',
                'driver_options' => [1014 => false],
            ]
        ]
    ],
    'resource' => ['default_setup' => ['connection' => 'default']],
    'install' => ['date' => 'Tue, 14 Apr 2026 19:19:27 +0000'],
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'compiled_config' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'graphql_query_resolver_result' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'config_webservice' => 1,
        'translate' => 1,
    ],
    'directories' => ['document_root_is_pub' => true],
];
