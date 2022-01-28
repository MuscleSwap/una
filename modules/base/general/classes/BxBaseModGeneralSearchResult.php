<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    BaseGeneral Base classes for modules
 * @ingroup     UnaModules
 *
 * @{
 */

define('BX_SYS_PER_PAGE_BROWSE_SHOWCASE', 32);

class BxBaseModGeneralSearchResult extends BxTemplSearchResult
{
    protected $oModule;
    protected $bShowcaseView = false;
    protected $aUnitViews = array();
    protected $sUnitViewDefault = 'gallery';

    function __construct($sMode = '', $aParams = array())
    {
        $this->_sMode = $sMode;
        parent::__construct();
    }

    function getMain()
    {
        return BxDolModule::getInstance($this->aCurrent['module_name']);
    }

    function getRssUnitLink (&$a)
    {
        $CNF = &$this->oModule->_oConfig->CNF;

        return BX_DOL_URL_ROOT . BxDolPermalinks::getInstance()->permalink('page.php?i=' . $CNF['URI_VIEW_ENTRY'] . '&id=' . $a[$CNF['FIELD_ID']]);
    }

    function getRssPageUrl ()
    {
        if (false === parent::getRssPageUrl())
            return false;

        $oPermalinks = BxDolPermalinks::getInstance();
        return BX_DOL_URL_ROOT . $oPermalinks->permalink($this->aCurrent['rss']['link']);
    }

    function rss ()
    {
        if (!isset($this->aCurrent['rss']))
            return '';

        $this->aCurrent['paginate']['perPage'] = empty($this->oModule->_oConfig->CNF['PARAM_NUM_RSS']) ? 10 : getParam($this->oModule->_oConfig->CNF['PARAM_NUM_RSS']);

        return parent::rss();
    }

    protected function addCustomConditions($CNF, $oProfile, $sMode, $aParams)
    {
        $this->addConditionsForAuthorStatus($CNF);

        $this->addConditionsForProhibitedCf($CNF);
        $this->addConditionsForViewerCf($CNF);
    }

    protected function addConditionsForAuthorStatus($CNF)
    {
        if (empty($CNF['FIELD_AUTHOR']))
            return;

        $this->aCurrent['restriction']['statusAuthor'] = [
            'value' => 'active',
            'field' => 'status',
            'operator' => '=',
            'table' => 'sys_profiles',
        ];

        $this->aCurrent['join']['statusAuthor'] = [
            'type' => 'INNER',
            'table' => 'sys_profiles',
            'mainField' => $CNF['FIELD_AUTHOR'],
            'onField' => 'id',
            'joinFields' => array(),
        ];
    }

    protected function addConditionsForProhibitedCf($CNF)
    {
        if(empty($CNF['FIELD_CF']))
            return;

        $sValues = getParam('sys_cf_prohibited');
        if(!$sValues)
            return;

        $aValues = explode(',', $sValues);
        if(!$aValues)
            return;

        $this->aCurrent['restriction']['prohibited_cf'] = [
            'value' => $aValues,
            'field' => $CNF['FIELD_CF'],
            'operator' => 'not in',
        ];
    }

    protected function addConditionsForViewerCf($CNF)
    {
        if(empty($CNF['FIELD_CF']) || !isLogged())
            return;

        $iViewer = bx_get_logged_profile_id();
        $aViewerInfo = BxDolProfileQuery::getInstance()->getInfoById($iViewer);
        if(empty($aViewerInfo) || !is_array($aViewerInfo))
            return;

        $this->aCurrent['restriction']['viewer_cf'] = [
            'value' => $aViewerInfo['cfw_value'],
            'field' => $CNF['FIELD_CF'],
            'operator' => 'in_set',
        ];
    }

    /**
     * Add conditions for private content
     */
    protected function addConditionsForPrivateContent($CNF, $oProfile, $aCustomGroup = array()) 
    {
        // default is bProcessPrivateContent = 1, 
        // so private items are shown as empty boxes with "Private" title

        // we can show public content when privacy object is available
        
        if(empty($CNF['OBJECT_PRIVACY_VIEW']))
            return;

        $oPrivacy = BxDolPrivacy::getObjectInstance($CNF['OBJECT_PRIVACY_VIEW']);
        if(!$oPrivacy)
            return;

        // for posts in some context we need to show all items, not only public content
        if (!empty($this->aCurrent['restriction']['context']['value']) || !empty($this->aCurrent['restriction']['author']['value'])) {
            $this->setProcessPrivateContent(true);
            return;
        }

        // build condition to show only public content
        $aCondition = $oPrivacy->getContentPublicAsCondition($oProfile ? $oProfile->id() : 0, $aCustomGroup);
        if(empty($aCondition) || !is_array($aCondition))
            return;

        if(isset($aCondition['restriction'])) {
            $this->aCurrent['restriction'] = array_merge($this->aCurrent['restriction'], $aCondition['restriction']);
            $this->aPrivateConditionsIndexes['restriction'] = array_keys($aCondition['restriction']);
        }
        if(isset($aCondition['join'])) {
            $this->aCurrent['join'] = array_merge($this->aCurrent['join'], $aCondition['join']);
            $this->aPrivateConditionsIndexes['join'] = array_keys($aCondition['join']);
        }

        $this->setProcessPrivateContent(false);
    }

    function showPagination($bAdmin = false, $bChangePage = true, $bPageReload = true)
    {
        if($this->bShowcaseView)
            return '';

        $sPagination = parent::showPagination ($bAdmin, $bChangePage, $bPageReload);
        if(empty($sPagination))
            return '';

        return $sPagination;
    }

    protected function getItemPerPageInShowCase ()
    {
        $iPerPageInShowCase = BX_SYS_PER_PAGE_BROWSE_SHOWCASE;
        $CNF = &$this->oModule->_oConfig->CNF;
        if (isset($CNF['PARAM_PER_PAGE_BROWSE_SHOWCASE']))
            $iPerPageInShowCase = getParam($CNF['PARAM_PER_PAGE_BROWSE_SHOWCASE']);
        return $iPerPageInShowCase;
    }
    
    function displayResultBlock()
    {
        if ($this->bShowcaseView) {
            $this->addContainerClass(array('bx-base-unit-showcase-wrapper'));
            $this->aCurrent['paginate']['perPage'] = $this->getItemPerPageInShowCase();
            $this->oModule->_oTemplate->addCss(array(BX_DIRECTORY_PATH_PLUGINS_PUBLIC . 'flickity/|flickity.css'));
            $this->oModule->_oTemplate->addJs(array('flickity/flickity.pkgd.min.js','modules/base/general/js/|showcase.js'));
        }

        return parent::displayResultBlock();
    }
}

/** @} */
