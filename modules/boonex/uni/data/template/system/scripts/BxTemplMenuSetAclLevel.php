<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) BoonEx Pty Limited - http://www.boonex.com/
 * CC-BY License - http://creativecommons.org/licenses/by/3.0/
 *
 * @defgroup    DolphinCore Dolphin Core
 * @{
 */

bx_import('BxBaseMenuSetAclLevel');

/**
 * @see BxDolMenu
 */
class BxTemplMenuSetAclLevel extends BxBaseMenuSetAclLevel {

    public function __construct ($aObject, $oTemplate = false) {
        parent::__construct ($aObject, $oTemplate);
    }
}

/** @} */
