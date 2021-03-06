<?php

namespace Doctrine\DBAL\Driver\PDOIbm;

use Doctrine\DBAL\Driver\AbstractDB2Driver;
use Doctrine\DBAL\Driver\PDO\Connection;

/**
 * Driver for the PDO IBM extension.
 *
 * @deprecated Use the driver based on the ibm_db2 extension instead.
 */
class Driver extends AbstractDB2Driver
{
    /**
     * {@inheritdoc}
     */
    public function connect(array $params, $username = null, $password = null, array $driverOptions = [])
    {
        return new Connection(
            $this->_constructPdoDsn($params),
            $username,
            $password,
            $driverOptions
        );
    }

    /**
     * Constructs the IBM PDO DSN.
     *
     * @param mixed[] $params
     *
     * @return string The DSN.
     */
    private function _constructPdoDsn(array $params)
    {
        $dsn = 'ibm:';
        if (isset($params['host'])) {
            $dsn .= 'HOSTNAME=' . $params['host'] . ';';
        }

        if (isset($params['port'])) {
            $dsn .= 'PORT=' . $params['port'] . ';';
        }

        $dsn .= 'PROTOCOL=TCPIP;';
        if (isset($params['dbname'])) {
            $dsn .= 'DATABASE=' . $params['dbname'] . ';';
        }

        return $dsn;
    }

    /**
     * {@inheritdoc}
     *
     * @deprecated
     */
    public function getName()
    {
        return 'pdo_ibm';
    }
}
