<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    Convos Convos
 * @ingroup     UnaModules
 *
 * @{
 */

/*
 * Module representation.
 */
class BxCnvTemplate extends BxBaseModTextTemplate
{
    /**
     * Constructor
     */
    function __construct(&$oConfig, &$oDb)
    {
        $this->MODULE = 'bx_convos';
        parent::__construct($oConfig, $oDb);
    }

    public function entryCollaborators ($aContentInfo, $iMaxVisible = 2, $sFloat = 'left')
    {
        $oModule = BxDolModule::getInstance($this->MODULE);
        $CNF = &$oModule->_oConfig->CNF;

        $aCollaborators = $this->_oDb->getCollaborators($aContentInfo[$CNF['FIELD_ID']]);
        //unset($aCollaborators[$aContentInfo[$CNF['FIELD_AUTHOR']]]);

        // sort collaborators: first - current user, second - last replier, third - author, all others sorted by max number of posts
        $aCollaborators = $oModule->sortCollaborators($aCollaborators, $aContentInfo['last_reply_profile_id'], $aContentInfo[$CNF['FIELD_AUTHOR']]);
        $iCollaboratorsNum = count($aCollaborators);

        // prepare template variables
        $aVarsPopup = array (
            'float' => 'none',
            'bx_repeat:collaborators' => array(),
            'bx_if:collaborators_more' => array(
                'condition' => false,
                'content' => array(),
            ),
        );
        $aVars = array (
            'float' => $sFloat,
            'bx_repeat:collaborators' => array(),
            'bx_if:collaborators_more' => array(
                'condition' => $iCollaboratorsNum > $iMaxVisible,
                'content' => array(
                    'popup' => '',
                    'title_more' => _t('_bx_cnv_more', $iCollaboratorsNum - $iMaxVisible),
                    'float' => $sFloat,
                    'id' => $this->MODULE . '-popup-' . $aContentInfo[$CNF['FIELD_ID']],
                ),
            ),
        );
        $i = 0;
        $aCollaborators = array_slice($aCollaborators, 0, 30, true);
        foreach ($aCollaborators as $iProfileId => $iReadComments) {
            $oProfile = BxDolProfile::getInstanceMagic($iProfileId);

            $aCollaborator = array (
                'id' => $oProfile->id(),
                'unit' => $oProfile->getUnit(0, array('template' => 'unit_wo_info')),
                'float' => $sFloat,
                'class' => $aContentInfo[$CNF['FIELD_AUTHOR']] == $iProfileId ? 'bx-cnv-collaborator-author' : '',
                'bx_if:last_replier' => array (
                    'condition' => ($aContentInfo['last_reply_profile_id'] == $iProfileId),
                    'content' => array (
                        'id' => $oProfile->id(),
                        'title' => bx_html_attribute(_t('_bx_cnv_collaborator_last_replier')),
                    ),
                ),
                'bx_if:author'  => array (
                    'condition' => $aContentInfo[$CNF['FIELD_AUTHOR']] == $iProfileId,
                    'content' => array (
                        'id' => $oProfile->id(),
                        'title' => bx_html_attribute(_t('_bx_cnv_collaborator_author')),
                    ),
                ),
            );

            if ($i < $iMaxVisible)
                $aVars['bx_repeat:collaborators'][] = $aCollaborator;
            if ($i >= $iMaxVisible)
                $aVarsPopup['bx_repeat:collaborators'][] = $aCollaborator;

            ++$i;
        }

        if ($aVarsPopup['bx_repeat:collaborators']) {
            $aVars['bx_if:collaborators_more']['content']['popup'] = BxTemplFunctions::getInstance()->transBox('', '<div class="bx-def-padding">' . $this->parseHtmlByName('collaborators.html', $aVarsPopup) . '</div>');
        }

        return $this->parseHtmlByName('collaborators.html', $aVars);
    }

    function getAuthorDesc ($aData, $oProfile)
    {
        $oModule = BxDolModule::getInstance($this->MODULE);
        if ($aData['last_reply_timestamp'] == $aData[$oModule->_oConfig->CNF['FIELD_ADDED']])
            return bx_time_js($aData[$oModule->_oConfig->CNF['FIELD_ADDED']], BX_FORMAT_DATE);

        return _t('_bx_cnv_author_desc', bx_time_js($aData[$oModule->_oConfig->CNF['FIELD_ADDED']], BX_FORMAT_DATE), bx_time_js($aData['last_reply_timestamp'], BX_FORMAT_DATE));
    }

    function getMessageLabel ($iCount, $r, $oProfileLast = null)
    {
        $oModule = BxDolModule::getInstance($this->MODULE);

        if (!$oProfileLast) {
            $oProfileLast = BxDolProfile::getInstance($r['last_reply_profile_id']);
            if (!$oProfileLast)
                $oProfileLast = BxDolProfileUndefined::getInstance();
        }

        if (!isset($r['unread_messages']))
            $r['unread_messages'] = $r['comments'] - $r['read_comments'];

        $bReadByAll = true;
        $aCollaborators = $oModule->_oDb->getCollaborators($r['id']);
        foreach ($aCollaborators as $iReadComments) {
            if ($r['comments'] - $iReadComments) {
                $bReadByAll = false;
                break;
            }
        }

        if (!isset($r['unread_messages']))
            $r['unread_messages'] = $r['comments'] - $r['read_comments'];

        return $this->parseHtmlByName('message_label.html', array (
            'count' => $iCount,
            'bx_if:unread_messages' => array (
                'condition' => $r['unread_messages'] > 0,
                'content' => array (
                    'unread_messages' => $r['unread_messages'],
                ),
            ),
            'bx_if:viewer_is_last_replier' => array (
                'condition' => !$bReadByAll && $oProfileLast->id() == bx_get_logged_profile_id(),
                'content' => array (),
            ),
            'bx_if:is_read_by_all' => array (
                'condition' => $bReadByAll,
                'content' => array (),
            ),
        ));
    }

    function getMessagesPreviews ($a)
    {
        if (empty($a))
            return MsgBox(_t('_Empty'));

        $oModule = BxDolModule::getInstance($this->MODULE);

        $aVars = array(
            'see_all_url' => bx_absolute_url(BxDolPermalinks::getInstance()->permalink($oModule->_oConfig->CNF['URL_HOME'])),
            'bx_repeat:messages' => array(),
        );
        foreach ($a as $r) {

            $oProfileAuthor = BxDolProfile::getInstance($r['author']);
            if (!$oProfileAuthor)
                $oProfileAuthor = BxDolProfileUndefined::getInstance();

            $oProfileLast = BxDolProfile::getInstance($r['last_reply_profile_id']);
            if (!$oProfileLast)
                $oProfileLast = BxDolProfileUndefined::getInstance();

            $sText = strmaxtextlen($r['text'], 90);
            $sTextCmt = strmaxtextlen($r['cmt_text'], 50);

            $aVars['bx_repeat:messages'][] = array (
                'id' => $r['id'],
                'url' => bx_absolute_url(BxDolPermalinks::getInstance()->permalink('page.php?i=' . $oModule->_oConfig->CNF['URI_VIEW_ENTRY'] . '&id=' . $r['id'])),
                'text' => $sText ? $sText : $oProfileAuthor->getDisplayName(),
                'cmt_text' => $sTextCmt,
                'unread_messages' => $r['unread_messages'],
                'last_reply_time_and_replier' => _t('_bx_cnv_x_date_by_x_replier', bx_time_js($r['last_reply_timestamp'], BX_FORMAT_DATE), $oProfileLast->getDisplayName()),
                'font_weight' => $r['unread_messages'] > 0 ? 'bold' : 'normal',
                'label' => $this->getMessageLabel($r['comments'] + 1, $r, $oProfileLast),

                'author_id' => $oProfileAuthor->id(),
                'author_url' => $oProfileAuthor->getUrl(),
                'author_title' => $oProfileAuthor->getDisplayName(),
                'author_title_attr' => bx_html_attribute($oProfileAuthor->getDisplayName()),
                'author_thumb_url' => $oProfileAuthor->getThumb(),

                'last_replier_id' => $oProfileLast->id(),
                'last_replier_url' => $oProfileLast->getUrl(),
                'last_replier_title' => $oProfileLast->getDisplayName(),
                'last_replier_title_attr' => bx_html_attribute($oProfileLast->getDisplayName()),
                'last_replier_thumb_url' => $oProfileLast->getThumb(),
            );
        }
        return $this->parseHtmlByName('messages_previews.html', $aVars);
    }

    function entryMessagePreviewInGrid ($r)
    {
        $oModule = BxDolModule::getInstance($this->MODULE);

        $oProfileLast = BxDolProfile::getInstance($r['last_reply_profile_id']);
        if (!$oProfileLast)
            $oProfileLast = BxDolProfileUndefined::getInstance();

        $sText = strmaxtextlen($r['text'], 100);
        $sTextCmt = $r['cmt_text'] ? strmaxtextlen($r['cmt_text'], 100) : '';

        if (!isset($r['unread_messages']))
            $r['unread_messages'] = $r['comments'] - $r['read_comments'];

        $aVars = array (
            'url' => bx_absolute_url(BxDolPermalinks::getInstance()->permalink('page.php?i=' . $oModule->_oConfig->CNF['URI_VIEW_ENTRY'] . '&id=' . $r['id'])),
            'text' => $sText ? $sText : _t('_Empty'),
            'cmt_text' => $sTextCmt,
            'last_reply_time_and_replier' => _t('_bx_cnv_x_date_by_x_replier', bx_time_js($r['last_reply_timestamp'], BX_FORMAT_DATE), $oProfileLast->getDisplayName()),
            'bx_if:unread_messages' => array (
                'condition' => $r['unread_messages'] > 0,
                'content' => array (),
            ),
        );
        $aVars['bx_if:unread_messages2'] = $aVars['bx_if:unread_messages'];
        return $this->parseHtmlByName('message_preview_in_grid.html', $aVars);
    }

    function getAuthorAddon ($aData, $oProfile)
    {
        return '';
    }

	public function entryBreadcrumb($aContentInfo, $aTmplVarsItems = array())
    {
        $CNF = &BxDolModule::getInstance($this->MODULE)->_oConfig->CNF;

        $oPermalink = BxDolPermalinks::getInstance();

        $oAuthor = BxDolProfile::getInstance($aContentInfo[$CNF['FIELD_AUTHOR']]);
		if(!$oAuthor)
			$oAuthor = BxDolProfileUndefined::getInstance();

        $sText = strmaxtextlen($aContentInfo[$CNF['FIELD_TEXT']], 50);
        $iFolder = $this->_oDb->getConversationFolder($aContentInfo[$CNF['FIELD_ID']], bx_get_logged_profile_id());

    	$aTmplVarsItems = array(array(
        	'url' => bx_absolute_url($oPermalink->permalink($CNF['URL_FOLDER'] . $iFolder)),
        	'title' => _t($CNF['T']['txt_folder_' . $iFolder])
        ), array(
        	'url' => bx_absolute_url($oPermalink->permalink('page.php?i=' . $CNF['URI_VIEW_ENTRY'] . '&id=' . $aContentInfo[$CNF['FIELD_ID']])),
        	'title' => $sText ? $sText : $oAuthor->getDisplayName(),
        ));

    	return parent::entryBreadcrumb($aContentInfo, $aTmplVarsItems);
    }
}

/** @} */
