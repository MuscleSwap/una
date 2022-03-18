<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    Credits Credits
 * @ingroup     UnaModules
 * 
 * @{
 */

class BxCreditsGridOrdersAdministration extends BxTemplGrid
{
    protected $_sModule;
    protected $_oModule;

    protected $_iUserId;

    public function __construct ($aOptions, $oTemplate = false)
    {
    	$this->_sModule = 'bx_credits';
    	$this->_oModule = BxDolModule::getInstance($this->_sModule);
    	if(!$oTemplate)
            $oTemplate = $this->_oModule->_oTemplate;

        parent::__construct ($aOptions, $oTemplate);

        $this->_sDefaultSortingOrder = 'DESC';
        $this->_aQueryReset = array($this->_aOptions['order_get_field'], $this->_aOptions['order_get_dir'], $this->_aOptions['paginate_get_start'], $this->_aOptions['paginate_get_per_page']);

        $iUserId = bx_get_logged_profile_id();
        if($iUserId !== false) {
            $this->_iUserId = (int)$iUserId;
            $this->_aQueryAppend['user_id'] = $this->_iUserId;
        }
    }

    protected function _getCellProfileId($mixedValue, $sKey, $aField, $aRow)
    {
        return parent::_getCellDefault($this->_getProfile($mixedValue), $sKey, $aField, $aRow);
    }

    protected function _getCellBundle($mixedValue, $sKey, $aField, $aRow)
    {
        $mixedValue = $this->_oTemplate->parseHtmlByName('bundle_link.html', [
            'href' => $this->_oModule->_oConfig->getBundleUrl(['id' => $aRow['bundle_id']]),
            'title' => bx_html_attribute($mixedValue),
            'content' => $mixedValue
        ]);

        return parent::_getCellDefault($mixedValue, $sKey, $aField, $aRow);
    }

    protected function _getCellType($mixedValue, $sKey, $aField, $aRow)
    {
        return parent::_getCellDefault(_t('_bx_credits_grid_column_value_ord_type_' . $mixedValue), $sKey, $aField, $aRow);
    }

    protected function _getCellAdded($mixedValue, $sKey, $aField, $aRow)
    {
        return parent::_getCellDefault(bx_time_js($mixedValue, BX_FORMAT_DATE, true), $sKey, $aField, $aRow);
    }

    protected function _getCellExpired($mixedValue, $sKey, $aField, $aRow)
    {
    	$mixedValue = (int)$mixedValue != 0 ? bx_time_js($mixedValue, BX_FORMAT_DATE, true): _t('_bx_credits_txt_never');
    		
        return parent::_getCellDefault($mixedValue, $sKey, $aField, $aRow);
    }

    protected function _getProfile($mixedValue) 
    {
        $oProfile = BxDolProfile::getInstanceMagic($mixedValue);
        if(!$oProfile)
            return $mixedValue;

        return $oProfile->getUnit(0, ['template' => ['name' => 'unit', 'size' => 'icon']]);
    }
}

/** @} */
