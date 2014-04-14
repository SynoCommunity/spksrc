// SuperBoxSelect
Ext.namespace('Ext.ux.form');
/**
 * <p>SuperBoxSelect is an extension of the ComboBox component that displays selected items as labelled boxes within the form field. As seen on facebook, hotmail and other sites.</p>
 * <p>The SuperBoxSelect component was inspired by the BoxSelect component found here: http://efattal.fr/en/extjs/extuxboxselect/</p>
 * 
 * @author <a href="mailto:dan.humphrey@technomedia.co.uk">Dan Humphrey</a>
 * @class Ext.ux.form.SuperBoxSelect
 * @extends Ext.form.ComboBox
 * @constructor
 * @component
 * @version 1.0
 * @license TBA (To be announced)
 * 
 */
Ext.ux.form.SuperBoxSelect = function (config) {
    Ext.ux.form.SuperBoxSelect.superclass.constructor.call(this, config);
    this.addEvents(
    /**
     * Fires before an item is added to the component via user interaction. Return false from the callback function to prevent the item from being added.
     * @event beforeadditem
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     * @param {Mixed} value The value of the item to be added
     */'beforeadditem',

    /**
     * Fires after a new item is added to the component.
     * @event additem
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     * @param {Mixed} value The value of the item which was added
     * @param {Record} record The store record which was added
     */'additem',

    /**
     * Fires when the allowAddNewData config is set to true, and a user attempts to add an item that is not in the data store.
     * @event newitem
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     * @param {Mixed} value The new item's value
     */'newitem',

    /**
     * Fires when an item's remove button is clicked. Return false from the callback function to prevent the item from being removed.
     * @event beforeremoveitem
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     * @param {Mixed} value The value of the item to be removed
     */'beforeremoveitem',

    /**
     * Fires after an item has been removed.
     * @event removeitem
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     * @param {Mixed} value The value of the item which was removed
     * @param {Record} record The store record which was removed
     */'removeitem',
    /**
     * Fires after the component values have been cleared.
     * @event clear
     * @memberOf Ext.ux.form.SuperBoxSelect
     * @param {SuperBoxSelect} this
     */'clear');

};
/**
 * @private hide from doc gen
 */
Ext.ux.form.SuperBoxSelect = Ext.extend(Ext.ux.form.SuperBoxSelect, Ext.form.ComboBox, {
    /**
     * @cfg {Boolean} allowAddNewData When set to true, allows items to be added (via the setValueEx and addItem methods) that do not already exist in the data store. Defaults to false.
     */
    allowAddNewData: false,

    /**
     * @cfg {Boolean} backspaceDeletesLastItem When set to false, the BACKSPACE key will focus the last selected item. When set to true, the last item will be immediately deleted. Defaults to true.
     */
    backspaceDeletesLastItem: true,

    /**
     * @cfg {String} classField The underlying data field that will be used to supply an additional class to each item.
     */
    classField: null,

    /**
     * @cfg {String} clearBtnCls An additional class to add to the in-field clear button.
     */
    clearBtnCls: '',

    /**
     * @cfg {String/XTemplate} displayFieldTpl A template for rendering the displayField in each selected item. Defaults to null.
     */
    displayFieldTpl: null,

    /**
     * @cfg {String} extraItemCls An additional css class to apply to each item.
     */
    extraItemCls: '',

    /**
     * @cfg {String/Object/Function} extraItemStyle Additional css style(s) to apply to each item. Should be a valid argument to Ext.Element.applyStyles.
     */
    extraItemStyle: '',

    /**
     * @cfg {String} expandBtnCls An additional class to add to the in-field expand button.
     */
    expandBtnCls: '',

    /**
     * @cfg {Boolean} fixFocusOnTabSelect When set to true, the component will not lose focus when a list item is selected with the TAB key. Defaults to true.
     */
    fixFocusOnTabSelect: true,

    /**
     * @cfg {Boolean} forceFormValue When set to true, the component will always return a value to the parent form getValues method, and when the parent form is submitted manually. Defaults to false, meaning the component will only be included in the parent form submission (or getValues) if at least 1 item has been selected.  
     */
    forceFormValue: true,
    /**
     * @cfg {Number} itemDelimiterKey The key code which terminates keying in of individual items, and adds the current
     * item to the list. Defaults to the ENTER key.
     */
    itemDelimiterKey: Ext.EventObject.ENTER,
    /**
     * @cfg {Boolean} navigateItemsWithTab When set to true the tab key will navigate between selected items. Defaults to true.
     */
    navigateItemsWithTab: true,

    /**
     * @cfg {Boolean} pinList When set to true the select list will be pinned to allow for multiple selections. Defaults to true.
     */
    pinList: true,

    /**
     * @cfg {Boolean} preventDuplicates When set to true unique item values will be enforced. Defaults to true.
     */
    preventDuplicates: true,

    /**
     * @cfg {String} queryValuesDelimiter Used to delimit multiple values queried from the server when mode is remote.
     */
    queryValuesDelimiter: '|',

    /**
     * @cfg {String} queryValuesIndicator A request variable that is sent to the server (as true) to indicate that we are querying values rather than display data (as used in autocomplete) when mode is remote.
     */
    queryValuesIndicator: 'valuesqry',

    /**
     * @cfg {Boolean} removeValuesFromStore When set to true, selected records will be removed from the store. Defaults to true.
     */
    removeValuesFromStore: true,

    /**
     * @cfg {String} renderFieldBtns When set to true, will render in-field buttons for clearing the component, and displaying the list for selection. Defaults to true.
     */
    renderFieldBtns: true,

    /**
     * @cfg {Boolean} stackItems When set to true, the items will be stacked 1 per line. Defaults to false which displays the items inline.
     */
    stackItems: false,

    /**
     * @cfg {String} styleField The underlying data field that will be used to supply additional css styles to each item.
     */
    styleField: null,

    /**
     * @cfg {Boolean} supressClearValueRemoveEvents When true, the removeitem event will not be fired for each item when the clearValue method is called, or when the clear button is used. Defaults to false.
     */
    supressClearValueRemoveEvents: false,

    /**
     * @cfg {String/Boolean} validationEvent The event that should initiate field validation. Set to false to disable automatic validation (defaults to 'blur').
     */
    validationEvent: 'blur',

    /**
     * @cfg {String} valueDelimiter The delimiter to use when joining and splitting value arrays and strings.
     */
    valueDelimiter: ',',
    initComponent: function () {
        Ext.apply(this, {
            items: new Ext.util.MixedCollection(false),
            usedRecords: new Ext.util.MixedCollection(false),
            addedRecords: [],
            remoteLookup: [],
            hideTrigger: true,
            grow: false,
            resizable: false,
            multiSelectMode: false,
            preRenderValue: null
        });

        if (this.transform) {
            this.doTransform();
        }
        if (this.forceFormValue) {
            this.items.on({
                add: this.manageNameAttribute,
                remove: this.manageNameAttribute,
                clear: this.manageNameAttribute,
                scope: this
            });
        }

        Ext.ux.form.SuperBoxSelect.superclass.initComponent.call(this);
        if (this.mode === 'remote' && this.store) {
            this.store.on('load', this.onStoreLoad, this);
        }
    },
    onRender: function (ct, position) {
        var h = this.hiddenName;
        this.hiddenName = null;
        Ext.ux.form.SuperBoxSelect.superclass.onRender.call(this, ct, position);
        this.hiddenName = h;
        this.manageNameAttribute();

        var extraClass = (this.stackItems === true) ? 'x-superboxselect-stacked' : '';
        if (this.renderFieldBtns) {
            extraClass += ' x-superboxselect-display-btns';
        }
        this.el.removeClass('x-form-text').addClass('x-superboxselect-input-field');

        this.wrapEl = this.el.wrap({
            tag: 'ul'
        });

        this.outerWrapEl = this.wrapEl.wrap({
            tag: 'div',
            cls: 'x-form-text x-superboxselect ' + extraClass
        });

        this.inputEl = this.el.wrap({
            tag: 'li',
            cls: 'x-superboxselect-input'
        });

        if (this.renderFieldBtns) {
            this.setupFieldButtons().manageClearBtn();
        }

        this.setupFormInterception();
    },
    onStoreLoad: function (store, records, options) {
        //accomodating for bug in Ext 3.0.0 where options.params are empty
        var q = options.params[this.queryParam] || store.baseParams[this.queryParam] || "",
            isValuesQuery = options.params[this.queryValuesIndicator] || store.baseParams[this.queryValuesIndicator];

        if (this.removeValuesFromStore) {
            this.store.each(function (record) {
                if (this.usedRecords.containsKey(record.get(this.valueField))) {
                    this.store.remove(record);
                }
            }, this);
        }
        //queried values
        if (isValuesQuery) {
            var params = q.split(this.queryValuesDelimiter);
            Ext.each(params,
            function (p) {
                this.remoteLookup.remove(p);
                var rec = this.findRecord(this.valueField, p);
                if (rec) {
                    this.addRecord(rec);
                }
            }, this);

            if (this.setOriginal) {
                this.setOriginal = false;
                this.originalValue = this.getValue();
            }
        }

        //queried display (autocomplete) & addItem
        if (q !== '' && this.allowAddNewData) {
            Ext.each(this.remoteLookup,
            function (r) {
                if (typeof r == "object" && r[this.displayField] == q) {
                    this.remoteLookup.remove(r);
                    if (records.length && records[0].get(this.displayField) === q) {
                        this.addRecord(records[0]);
                        return;
                    }
                    var rec = this.createRecord(r);
                    this.store.add(rec);
                    this.addRecord(rec);
                    this.addedRecords.push(rec); //keep track of records added to store
                    (function () {
                        if (this.isExpanded()) {
                            this.collapse();
                        }
                    }).defer(10, this);
                    return;
                }
            }, this);
        }

        var toAdd = [];
        if (q === '') {
            Ext.each(this.addedRecords,
            function (rec) {
                if (this.preventDuplicates && this.usedRecords.containsKey(rec.get(this.valueField))) {
                    return;
                }
                toAdd.push(rec);

            }, this);

        } else {
            var re = new RegExp(Ext.escapeRe(q) + '.*', 'i');
            Ext.each(this.addedRecords,
            function (rec) {
                if (this.preventDuplicates && this.usedRecords.containsKey(rec.get(this.valueField))) {
                    return;
                }
                if (re.test(rec.get(this.displayField))) {
                    toAdd.push(rec);
                }
            }, this);
        }
        this.store.add(toAdd);
        this.store.sort(this.displayField, 'ASC');

        if (this.store.getCount() === 0 && this.isExpanded()) {
            this.collapse();
        }

    },
    doTransform: function () {
        var s = Ext.getDom(this.transform),
            transformValues = [];
        if (!this.store) {
            this.mode = 'local';
            var d = [],
                opts = s.options;
            for (var i = 0, len = opts.length; i < len; i++) {
                var o = opts[i],
                    oe = Ext.get(o),
                    value = oe.getAttributeNS(null, 'value') || '',
                    cls = oe.getAttributeNS(null, 'className') || '',
                    style = oe.getAttributeNS(null, 'style') || '';
                if (o.selected) {
                    transformValues.push(value);
                }
                d.push([value, o.text, cls, typeof (style) === "string" ? style : style.cssText]);
            }
            this.store = new Ext.data.SimpleStore({
                'id': 0,
                fields: ['value', 'text', 'cls', 'style'],
                data: d
            });
            Ext.apply(this, {
                valueField: 'value',
                displayField: 'text',
                classField: 'cls',
                styleField: 'style'
            });
        }

        if (transformValues.length) {
            this.value = transformValues.join(',');
        }
    },
    setupFieldButtons: function () {
        this.buttonWrap = this.outerWrapEl.createChild({
            cls: 'x-superboxselect-btns'
        });

        this.buttonClear = this.buttonWrap.createChild({
            tag: 'div',
            cls: 'x-superboxselect-btn-clear ' + this.clearBtnCls
        });

        this.buttonExpand = this.buttonWrap.createChild({
            tag: 'div',
            cls: 'x-superboxselect-btn-expand ' + this.expandBtnCls
        });

        this.initButtonEvents();

        return this;
    },
    initButtonEvents: function () {
        this.buttonClear.addClassOnOver('x-superboxselect-btn-over').on('click',
        function (e) {
            e.stopEvent();
            if (this.disabled) {
                return;
            }
            this.clearValue();
            this.el.focus();
        }, this);

        this.buttonExpand.addClassOnOver('x-superboxselect-btn-over').on('click',
        function (e) {
            e.stopEvent();
            if (this.disabled) {
                return;
            }
            if (this.isExpanded()) {
                this.multiSelectMode = false;
            } else if (this.pinList) {
                this.multiSelectMode = true;
            }
            this.onTriggerClick();
        }, this);
    },
    removeButtonEvents: function () {
        this.buttonClear.removeAllListeners();
        this.buttonExpand.removeAllListeners();
        return this;
    },
    clearCurrentFocus: function () {
        if (this.currentFocus) {
            this.currentFocus.onLnkBlur();
            this.currentFocus = null;
        }
        return this;
    },
    initEvents: function () {
        var el = this.el;

        el.on({
            click: this.onClick,
            focus: this.clearCurrentFocus,
            blur: this.onBlur,

            keydown: this.onKeyDownHandler,
            keyup: this.onKeyUpBuffered,

            scope: this
        });

        this.on({
            collapse: this.onCollapse,
            expand: this.clearCurrentFocus,
            scope: this
        });

        this.wrapEl.on('click', this.onWrapClick, this);
        this.outerWrapEl.on('click', this.onWrapClick, this);

        this.inputEl.focus = function () {
            el.focus();
        };

        Ext.ux.form.SuperBoxSelect.superclass.initEvents.call(this);

        Ext.apply(this.keyNav, {
            tab: function (e) {
                if (this.fixFocusOnTabSelect && this.isExpanded()) {
                    e.stopEvent();
                    el.blur();
                    this.onViewClick(false);
                    this.focus(false, 10);
                    return true;
                }

                this.onViewClick(false);
                if (el.dom.value !== '') {
                    this.setRawValue('');
                }

                return true;
            },

            down: function (e) {
                if (!this.isExpanded() && !this.currentFocus) {
                    this.onTriggerClick();
                } else {
                    this.inKeyMode = true;
                    this.selectNext();
                }
            },

            enter: function () {}
        });
    },

    onClick: function () {
        this.clearCurrentFocus();
        this.collapse();
        this.autoSize();
    },

    beforeBlur: Ext.form.ComboBox.superclass.beforeBlur,

    onFocus: function () {
        this.outerWrapEl.addClass(this.focusClass);

        Ext.ux.form.SuperBoxSelect.superclass.onFocus.call(this);
    },

    onBlur: function () {
        this.outerWrapEl.removeClass(this.focusClass);

        this.clearCurrentFocus();

        if (this.el.dom.value !== '') {
            this.applyEmptyText();
            this.autoSize();
        }

        Ext.ux.form.SuperBoxSelect.superclass.onBlur.call(this);
    },

    onCollapse: function () {
        this.view.clearSelections();
        this.multiSelectMode = false;
    },

    onWrapClick: function (e) {
        e.stopEvent();
        this.collapse();
        this.el.focus();
        this.clearCurrentFocus();
    },
    markInvalid: function (msg) {
        var elp, t;

        if (!this.rendered || this.preventMark) {
            return;
        }
        this.outerWrapEl.addClass(this.invalidClass);
        msg = msg || this.invalidText;

        switch (this.msgTarget) {
        case 'qtip':
            Ext.apply(this.el.dom, {
                qtip: msg,
                qclass: 'x-form-invalid-tip'
            });
            Ext.apply(this.wrapEl.dom, {
                qtip: msg,
                qclass: 'x-form-invalid-tip'
            });
            if (Ext.QuickTips) { // fix for floating editors interacting with DND
                Ext.QuickTips.enable();
            }
            break;
        case 'title':
            this.el.dom.title = msg;
            this.wrapEl.dom.title = msg;
            this.outerWrapEl.dom.title = msg;
            break;
        case 'under':
            if (!this.errorEl) {
                elp = this.getErrorCt();
                if (!elp) { // field has no container el
                    this.el.dom.title = msg;
                    break;
                }
                this.errorEl = elp.createChild({
                    cls: 'x-form-invalid-msg'
                });
                this.errorEl.setWidth(elp.getWidth(true) - 20);
            }
            this.errorEl.update(msg);
            Ext.form.Field.msgFx[this.msgFx].show(this.errorEl, this);
            break;
        case 'side':
            if (!this.errorIcon) {
                elp = this.getErrorCt();
                if (!elp) { // field has no container el
                    this.el.dom.title = msg;
                    break;
                }
                this.errorIcon = elp.createChild({
                    cls: 'x-form-invalid-icon'
                });
            }
            this.alignErrorIcon();
            Ext.apply(this.errorIcon.dom, {
                qtip: msg,
                qclass: 'x-form-invalid-tip'
            });
            this.errorIcon.show();
            this.on('resize', this.alignErrorIcon, this);
            break;
        default:
            t = Ext.getDom(this.msgTarget);
            t.innerHTML = msg;
            t.style.display = this.msgDisplay;
            break;
        }
        this.fireEvent('invalid', this, msg);
    },
    clearInvalid: function () {
        if (!this.rendered || this.preventMark) { // not rendered
            return;
        }
        this.outerWrapEl.removeClass(this.invalidClass);
        switch (this.msgTarget) {
        case 'qtip':
            this.el.dom.qtip = '';
            this.wrapEl.dom.qtip = '';
            break;
        case 'title':
            this.el.dom.title = '';
            this.wrapEl.dom.title = '';
            this.outerWrapEl.dom.title = '';
            break;
        case 'under':
            if (this.errorEl) {
                Ext.form.Field.msgFx[this.msgFx].hide(this.errorEl, this);
            }
            break;
        case 'side':
            if (this.errorIcon) {
                this.errorIcon.dom.qtip = '';
                this.errorIcon.hide();
                this.un('resize', this.alignErrorIcon, this);
            }
            break;
        default:
            var t = Ext.getDom(this.msgTarget);
            t.innerHTML = '';
            t.style.display = 'none';
            break;
        }
        this.fireEvent('valid', this);
    },
    alignErrorIcon: function () {
        if (this.wrap) {
            this.errorIcon.alignTo(this.wrap, 'tl-tr', [Ext.isIE ? 5 : 2, 3]);
        }
    },
    expand: function () {
        if (this.isExpanded() || !this.hasFocus) {
            return;
        }
        this.list.alignTo(this.outerWrapEl, this.listAlign).show();
        this.innerList.setOverflow('auto'); // necessary for FF 2.0/Mac
        Ext.getDoc().on({
            mousewheel: this.collapseIf,
            mousedown: this.collapseIf,
            scope: this
        });
        this.fireEvent('expand', this);
    },
    restrictHeight: function () {
        var inner = this.innerList.dom,
            st = inner.scrollTop,
            list = this.list;

        inner.style.height = '';

        var pad = list.getFrameWidth('tb') + (this.resizable ? this.handleHeight : 0) + this.assetHeight,
            h = Math.max(inner.clientHeight, inner.offsetHeight, inner.scrollHeight),
            ha = this.getPosition()[1] - Ext.getBody().getScroll().top,
            hb = Ext.lib.Dom.getViewHeight() - ha - this.getSize().height,
            space = Math.max(ha, hb, this.minHeight || 0) - list.shadowOffset - pad - 5;

        h = Math.min(h, space, this.maxHeight);
        this.innerList.setHeight(h);

        list.beginUpdate();
        list.setHeight(h + pad);
        list.alignTo(this.outerWrapEl, this.listAlign);
        list.endUpdate();

        if (this.multiSelectMode) {
            inner.scrollTop = st;
        }
    },

    validateValue: function (val) {
        if (this.items.getCount() === 0) {
            if (this.allowBlank) {
                this.clearInvalid();
                return true;
            } else {
                this.markInvalid(this.blankText);
                return false;
            }
        }

        this.clearInvalid();
        return true;
    },

    manageNameAttribute: function () {
        if (this.items.getCount() === 0 && this.forceFormValue) {
            this.el.dom.setAttribute('name', this.hiddenName || this.name);
        } else {
            this.el.dom.removeAttribute('name');
        }
    },
    setupFormInterception: function () {
        var form;
        this.findParentBy(function (p) {
            if (p.getForm) {
                form = p.getForm();
            }
        });
        if (form) {

            var formGet = form.getValues;
            form.getValues = function (asString) {
                this.el.dom.disabled = true;
                var oldVal = this.el.dom.value;
                this.setRawValue('');
                var vals = formGet.call(form);
                this.el.dom.disabled = false;
                this.setRawValue(oldVal);
                if (this.forceFormValue && this.items.getCount() === 0) {
                    vals[this.name] = '';
                }
                return asString ? Ext.urlEncode(vals) : vals;
            }.createDelegate(this);
        }
    },
    onResize: function (w, h, rw, rh) {
        var reduce = Ext.isIE6 ? 4 : Ext.isIE7 ? 1 : Ext.isIE8 ? 1 : 0;
        if (this.wrapEl) {
            this._width = w;
            this.outerWrapEl.setWidth(w - reduce);
            if (this.renderFieldBtns) {
                reduce += (this.buttonWrap.getWidth() + 20);
                this.wrapEl.setWidth(w - reduce);
            }
        }
        Ext.ux.form.SuperBoxSelect.superclass.onResize.call(this, w, h, rw, rh);
        this.autoSize();
    },
    onEnable: function () {
        Ext.ux.form.SuperBoxSelect.superclass.onEnable.call(this);
        this.items.each(function (item) {
            item.enable();
        });
        if (this.renderFieldBtns) {
            this.initButtonEvents();
        }
    },
    onDisable: function () {
        Ext.ux.form.SuperBoxSelect.superclass.onDisable.call(this);
        this.items.each(function (item) {
            item.disable();
        });
        if (this.renderFieldBtns) {
            this.removeButtonEvents();
        }
    },
    /**
     * Clears all values from the component.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name clearValue
     * @param {Boolean} supressRemoveEvent [Optional] When true, the 'removeitem' event will not fire for each item that is removed.    
     */
    clearValue: function (supressRemoveEvent) {
        Ext.ux.form.SuperBoxSelect.superclass.clearValue.call(this);
        this.preventMultipleRemoveEvents = supressRemoveEvent || this.supressClearValueRemoveEvents || false;
        this.removeAllItems();
        this.preventMultipleRemoveEvents = false;
        this.fireEvent('clear', this);
        return this;
    },
    onKeyUp: function (e) {
        if (this.editable !== false && (!e.isSpecialKey() || e.getKey() === e.BACKSPACE) && e.getKey() !== this.itemDelimiterKey && (!e.hasModifier() || e.shiftKey)) {
            this.lastKey = e.getKey();
            this.dqTask.delay(this.queryDelay);
        }
    },
    onKeyDownHandler: function (e, t) {

        var toDestroy, nextFocus, idx;
        if ((e.getKey() === e.DELETE || e.getKey() === e.SPACE) && this.currentFocus) {
            e.stopEvent();
            toDestroy = this.currentFocus;
            this.on('expand',
            function () {
                this.collapse();
            }, this, {
                single: true
            });
            idx = this.items.indexOfKey(this.currentFocus.key);

            this.clearCurrentFocus();

            if (idx < (this.items.getCount() - 1)) {
                nextFocus = this.items.itemAt(idx + 1);
            }

            toDestroy.preDestroy(true);
            if (nextFocus) {
                (function () {
                    nextFocus.onLnkFocus();
                    this.currentFocus = nextFocus;
                }).defer(200, this);
            }

            return true;
        }

        var val = this.el.dom.value,
            it, ctrl = e.ctrlKey;
        if (e.getKey() === this.itemDelimiterKey) {
            e.stopEvent();
            if (val !== "") {
                if (ctrl || !this.isExpanded()) { //ctrl+enter for new items
                    this.view.clearSelections();
                    this.collapse();
                    this.setRawValue('');
                    this.fireEvent('newitem', this, val);
                } else {
                    this.onViewClick();
                    //removed from 3.0.1
                    if (this.unsetDelayCheck) {
                        this.delayedCheck = true;
                        this.unsetDelayCheck.defer(10, this);
                    }
                }
            } else {
                if (!this.isExpanded()) {
                    return;
                }
                this.onViewClick();
                //removed from 3.0.1
                if (this.unsetDelayCheck) {
                    this.delayedCheck = true;
                    this.unsetDelayCheck.defer(10, this);
                }
            }
            return true;
        }

        if (val !== '') {
            this.autoSize();
            return;
        }

        //select first item
        if (e.getKey() === e.HOME) {
            e.stopEvent();
            if (this.items.getCount() > 0) {
                this.collapse();
                it = this.items.get(0);
                it.el.focus();

            }
            return true;
        }
        //backspace remove
        if (e.getKey() === e.BACKSPACE) {
            e.stopEvent();
            if (this.currentFocus) {
                toDestroy = this.currentFocus;
                this.on('expand',
                function () {
                    this.collapse();
                }, this, {
                    single: true
                });

                idx = this.items.indexOfKey(toDestroy.key);

                this.clearCurrentFocus();
                if (idx < (this.items.getCount() - 1)) {
                    nextFocus = this.items.itemAt(idx + 1);
                }

                toDestroy.preDestroy(true);

                if (nextFocus) {
                    (function () {
                        nextFocus.onLnkFocus();
                        this.currentFocus = nextFocus;
                    }).defer(200, this);
                }

                return;
            } else {
                it = this.items.get(this.items.getCount() - 1);
                if (it) {
                    if (this.backspaceDeletesLastItem) {
                        this.on('expand',
                        function () {
                            this.collapse();
                        }, this, {
                            single: true
                        });
                        it.preDestroy(true);
                    } else {
                        if (this.navigateItemsWithTab) {
                            it.onElClick();
                        } else {
                            this.on('expand',
                            function () {
                                this.collapse();
                                this.currentFocus = it;
                                this.currentFocus.onLnkFocus.defer(20, this.currentFocus);
                            }, this, {
                                single: true
                            });
                        }
                    }
                }
                return true;
            }
        }

        if (!e.isNavKeyPress()) {
            this.multiSelectMode = false;
            this.clearCurrentFocus();
            return;
        }
        //arrow nav
        if (e.getKey() === e.LEFT || (e.getKey() === e.UP && !this.isExpanded())) {
            e.stopEvent();
            this.collapse();
            //get last item
            it = this.items.get(this.items.getCount() - 1);
            if (this.navigateItemsWithTab) {
                //focus last el
                if (it) {
                    it.focus();
                }
            } else {
                //focus prev item
                if (this.currentFocus) {
                    idx = this.items.indexOfKey(this.currentFocus.key);
                    this.clearCurrentFocus();

                    if (idx !== 0) {
                        this.currentFocus = this.items.itemAt(idx - 1);
                        this.currentFocus.onLnkFocus();
                    }
                } else {
                    this.currentFocus = it;
                    if (it) {
                        it.onLnkFocus();
                    }
                }
            }
            return true;
        }
        if (e.getKey() === e.DOWN) {
            if (this.currentFocus) {
                this.collapse();
                e.stopEvent();
                idx = this.items.indexOfKey(this.currentFocus.key);
                if (idx == (this.items.getCount() - 1)) {
                    this.clearCurrentFocus.defer(10, this);
                } else {
                    this.clearCurrentFocus();
                    this.currentFocus = this.items.itemAt(idx + 1);
                    if (this.currentFocus) {
                        this.currentFocus.onLnkFocus();
                    }
                }
                return true;
            }
        }
        if (e.getKey() === e.RIGHT) {
            this.collapse();
            it = this.items.itemAt(0);
            if (this.navigateItemsWithTab) {
                //focus first el
                if (it) {
                    it.focus();
                }
            } else {
                if (this.currentFocus) {
                    idx = this.items.indexOfKey(this.currentFocus.key);
                    this.clearCurrentFocus();
                    if (idx < (this.items.getCount() - 1)) {
                        this.currentFocus = this.items.itemAt(idx + 1);
                        if (this.currentFocus) {
                            this.currentFocus.onLnkFocus();
                        }
                    }
                } else {
                    this.currentFocus = it;
                    if (it) {
                        it.onLnkFocus();
                    }
                }
            }
        }
    },
    onKeyUpBuffered: function (e) {
        if (!e.isNavKeyPress()) {
            this.autoSize();
        }
    },
    reset: function () {
        this.killItems();
        Ext.ux.form.SuperBoxSelect.superclass.reset.call(this);
        this.addedRecords = [];
        this.autoSize().setRawValue('');
    },
    applyEmptyText: function () {
        this.setRawValue('');
        if (this.items.getCount() > 0) {
            this.el.removeClass(this.emptyClass);
            this.setRawValue('');
            return this;
        }
        if (this.rendered && this.emptyText && this.getRawValue().length < 1) {
            this.setRawValue(this.emptyText);
            this.el.addClass(this.emptyClass);
        }
        return this;
    },
    /**
     * @private
     * 
     * Use clearValue instead
     */
    removeAllItems: function () {
        this.items.each(function (item) {
            item.preDestroy(true);
        }, this);
        this.manageClearBtn();
        return this;
    },
    killItems: function () {
        this.items.each(function (item) {
            item.kill();
        }, this);
        this.resetStore();
        this.items.clear();
        this.manageClearBtn();
        return this;
    },
    resetStore: function () {
        this.store.clearFilter();
        if (!this.removeValuesFromStore) {
            return this;
        }
        this.usedRecords.each(function (rec) {
            this.store.add(rec);
        }, this);
        this.usedRecords.clear();
        this.sortStore();
        return this;
    },
    sortStore: function () {
        var ss = this.store.getSortState();
        if (ss && ss.field) {
            this.store.sort(ss.field, ss.direction);
        }
        return this;
    },
    getCaption: function (dataObject) {
        if (typeof this.displayFieldTpl === 'string') {
            this.displayFieldTpl = new Ext.XTemplate(this.displayFieldTpl);
        }
        var caption, recordData = dataObject instanceof Ext.data.Record ? dataObject.data : dataObject;

        if (this.displayFieldTpl) {
            caption = this.displayFieldTpl.apply(recordData);
        } else if (this.displayField) {
            caption = recordData[this.displayField];
        }

        return caption;
    },
    addRecord: function (record) {
        var display = record.data[this.displayField],
            caption = this.getCaption(record),
            val = record.data[this.valueField],
            cls = this.classField ? record.data[this.classField] : '',
            style = this.styleField ? record.data[this.styleField] : '';

        if (this.removeValuesFromStore) {
            this.usedRecords.add(val, record);
            this.store.remove(record);
        }

        this.addItemBox(val, display, caption, cls, style);
        this.fireEvent('additem', this, val, record);
    },
    createRecord: function (recordData) {
        if (!this.recordConstructor) {
            var recordFields = [{
                name: this.valueField
            }, {
                name: this.displayField
            }];
            if (this.classField) {
                recordFields.push({
                    name: this.classField
                });
            }
            if (this.styleField) {
                recordFields.push({
                    name: this.styleField
                });
            }
            this.recordConstructor = Ext.data.Record.create(recordFields);
        }
        return new this.recordConstructor(recordData);
    },
    /**
     * Adds an array of items to the SuperBoxSelect component if the {@link #Ext.ux.form.SuperBoxSelect-allowAddNewData} config is set to true.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name addItem
     * @param {Array} newItemObjects An Array of object literals containing the property names and values for an item. The property names must match those specified in {@link #Ext.ux.form.SuperBoxSelect-displayField}, {@link #Ext.ux.form.SuperBoxSelect-valueField} and {@link #Ext.ux.form.SuperBoxSelect-classField} 
     */
    addItems: function (newItemObjects) {
        if (Ext.isArray(newItemObjects)) {
            Ext.each(newItemObjects,
            function (item) {
                this.addItem(item);
            }, this);
        } else {
            this.addItem(newItemObjects);
        }
    },
    /**
     * Adds a new non-existing item to the SuperBoxSelect component if the {@link #Ext.ux.form.SuperBoxSelect-allowAddNewData} config is set to true.
     * This method should be used in place of addItem from within the newitem event handler.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name addNewItem
     * @param {Object} newItemObject An object literal containing the property names and values for an item. The property names must match those specified in {@link #Ext.ux.form.SuperBoxSelect-displayField}, {@link #Ext.ux.form.SuperBoxSelect-valueField} and {@link #Ext.ux.form.SuperBoxSelect-classField} 
     */
    addNewItem: function (newItemObject) {
        this.addItem(newItemObject, true);
    },
    /**
     * Adds an item to the SuperBoxSelect component if the {@link #Ext.ux.form.SuperBoxSelect-allowAddNewData} config is set to true.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name addItem
     * @param {Object} newItemObject An object literal containing the property names and values for an item. The property names must match those specified in {@link #Ext.ux.form.SuperBoxSelect-displayField}, {@link #Ext.ux.form.SuperBoxSelect-valueField} and {@link #Ext.ux.form.SuperBoxSelect-classField} 
     */
    addItem: function (newItemObject, /*hidden param*/ forcedAdd) {

        var val = newItemObject[this.valueField];

        if (this.disabled) {
            return false;
        }
        if (this.preventDuplicates && this.hasValue(val)) {
            return;
        }

        //use existing record if found
        var record = this.findRecord(this.valueField, val);
        if (record) {
            this.addRecord(record);
            return;
        } else if (!this.allowAddNewData) { // else it's a new item
            return;
        }

        if (this.mode === 'remote') {
            this.remoteLookup.push(newItemObject);
            this.doQuery(val, false, false, forcedAdd);
            return;
        }

        var rec = this.createRecord(newItemObject);
        this.store.add(rec);
        this.addRecord(rec);

        return true;
    },
    addItemBox: function (itemVal, itemDisplay, itemCaption, itemClass, itemStyle) {
        var hConfig, parseStyle = function (s) {
                var ret = '';
                if (typeof s == 'function') {
                    ret = s.call();
                } else if (typeof s == 'object') {
                    for (var p in s) {
                        ret += p + ':' + s[p] + ';';
                    }
                } else if (typeof s == 'string') {
                    ret = s + ';';
                }
                return ret;
            },
            itemKey = Ext.id(null, 'sbx-item'),
            box = new Ext.ux.form.SuperBoxSelectItem({
                owner: this,
                disabled: this.disabled,
                renderTo: this.wrapEl,
                cls: this.extraItemCls + ' ' + itemClass,
                style: parseStyle(this.extraItemStyle) + ' ' + itemStyle,
                caption: itemCaption,
                display: itemDisplay,
                value: itemVal,
                key: itemKey,
                listeners: {
                    'remove': function (item) {
                        if (this.fireEvent('beforeremoveitem', this, item.value) === false) {
                            return;
                        }
                        this.items.removeKey(item.key);
                        if (this.removeValuesFromStore) {
                            if (this.usedRecords.containsKey(item.value)) {
                                this.store.add(this.usedRecords.get(item.value));
                                this.usedRecords.removeKey(item.value);
                                this.sortStore();
                                if (this.view) {
                                    this.view.render();
                                }
                            }
                        }
                        if (!this.preventMultipleRemoveEvents) {
                            this.fireEvent.defer(250, this, ['removeitem', this, item.value, this.findInStore(item.value)]);
                        }
                    },
                    destroy: function () {
                        this.collapse();
                        this.autoSize().manageClearBtn().validateValue();
                    },
                    scope: this
                }
            });
        box.render();

        hConfig = {
            tag: 'input',
            type: 'hidden',
            value: itemVal,
            name: (this.hiddenName || this.name)
        };

        if (this.disabled) {
            Ext.apply(hConfig, {
                disabled: 'disabled'
            })
        }
        box.hidden = this.el.insertSibling(hConfig, 'before');

        this.items.add(itemKey, box);
        this.applyEmptyText().autoSize().manageClearBtn().validateValue();
    },
    manageClearBtn: function () {
        if (!this.renderFieldBtns || !this.rendered) {
            return this;
        }
        var cls = 'x-superboxselect-btn-hide';
        if (this.items.getCount() === 0) {
            this.buttonClear.addClass(cls);
        } else {
            this.buttonClear.removeClass(cls);
        }
        return this;
    },
    findInStore: function (val) {
        var index = this.store.find(this.valueField, val);
        if (index > -1) {
            return this.store.getAt(index);
        }
        return false;
    },
    /**
     * Returns a String value containing a concatenated list of item values. The list is concatenated with the {@link #Ext.ux.form.SuperBoxSelect-valueDelimiter}.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name getValue
     * @return {String} a String value containing a concatenated list of item values. 
     */
    getValue: function () {
        var ret = [];
        this.items.each(function (item) {
            ret.push(item.value);
        });
        return ret.join(this.valueDelimiter);
    },
    /**
     * Returns an Array of item objects containing the {@link #Ext.ux.form.SuperBoxSelect-displayField}, {@link #Ext.ux.form.SuperBoxSelect-valueField}, {@link #Ext.ux.form.SuperBoxSelect-classField} and {@link #Ext.ux.form.SuperBoxSelect-styleField} properties.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name getValueEx
     * @return {Array} an array of item objects. 
     */
    getValueEx: function () {
        var ret = [];
        this.items.each(function (item) {
            var newItem = {};
            newItem[this.valueField] = item.value;
            newItem[this.displayField] = item.display;
            if (this.classField) {
                newItem[this.classField] = item.cls || '';
            }
            if (this.styleField) {
                newItem[this.styleField] = item.style || '';
            }
            ret.push(newItem);
        }, this);
        return ret;
    },
    // private
    initValue: function () {

        Ext.ux.form.SuperBoxSelect.superclass.initValue.call(this);
        if (this.mode === 'remote') {
            this.setOriginal = true;
        }
    },
    /**
     * Sets the value of the SuperBoxSelect component.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name setValue
     * @param {String|Array} value An array of item values, or a String value containing a delimited list of item values. (The list should be delimited with the {@link #Ext.ux.form.SuperBoxSelect-valueDelimiter) 
     */
    setValue: function (value) {
        if (!this.rendered) {
            this.value = value;
            return;
        }

        this.removeAllItems().resetStore();
        this.remoteLookup = [];

        if (Ext.isEmpty(value)) {
            return;
        }

        var values = value;
        if (!Ext.isArray(value)) {
            value = '' + value;
            values = value.split(this.valueDelimiter);
        }

        Ext.each(values,
        function (val) {
            var record = this.findRecord(this.valueField, val);
            if (record) {
                this.addRecord(record);
            } else if (this.mode === 'remote') {
                this.remoteLookup.push(val);
            }
        }, this);

        if (this.mode === 'remote') {
            var q = this.remoteLookup.join(this.queryValuesDelimiter);
            this.doQuery(q, false, true); //3rd param to specify a values query
        }

    },
    /**
     * Sets the value of the SuperBoxSelect component, adding new items that don't exist in the data store if the {@link #Ext.ux.form.SuperBoxSelect-allowAddNewData} config is set to true.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name setValue
     * @param {Array} data An Array of item objects containing the {@link #Ext.ux.form.SuperBoxSelect-displayField}, {@link #Ext.ux.form.SuperBoxSelect-valueField} and {@link #Ext.ux.form.SuperBoxSelect-classField} properties.  
     */
    setValueEx: function (data) {
        this.removeAllItems().resetStore();

        if (!Ext.isArray(data)) {
            data = [data];
        }
        this.remoteLookup = [];

        if (this.allowAddNewData && this.mode === 'remote') { // no need to query
            Ext.each(data,
            function (d) {
                var r = this.findRecord(this.valueField, d[this.valueField]) || this.createRecord(d);
                this.addRecord(r);
            }, this);
            return;
        }

        Ext.each(data,
        function (item) {
            this.addItem(item);
        }, this);
    },
    /**
     * Returns true if the SuperBoxSelect component has a selected item with a value matching the 'val' parameter.
     * @methodOf Ext.ux.form.SuperBoxSelect
     * @name hasValue
     * @param {Mixed} val The value to test.
     * @return {Boolean} true if the component has the selected value, false otherwise.
     */
    hasValue: function (val) {
        var has = false;
        this.items.each(function (item) {
            if (item.value == val) {
                has = true;
                return false;
            }
        }, this);
        return has;
    },
    onSelect: function (record, index) {
        if (this.fireEvent('beforeselect', this, record, index) !== false) {
            var val = record.data[this.valueField];

            if (this.preventDuplicates && this.hasValue(val)) {
                return;
            }

            this.setRawValue('');
            this.lastSelectionText = '';

            if (this.fireEvent('beforeadditem', this, val) !== false) {
                this.addRecord(record);
            }
            if (this.store.getCount() === 0 || !this.multiSelectMode) {
                this.collapse();
            } else {
                this.restrictHeight();
            }
        }
    },
    onDestroy: function () {
        this.items.purgeListeners();
        this.killItems();
        if (this.renderFieldBtns) {
            Ext.destroy(
            this.buttonClear,
            this.buttonExpand,
            this.buttonWrap);
        }

        Ext.destroy(
        this.inputEl,
        this.wrapEl,
        this.outerWrapEl);

        Ext.ux.form.SuperBoxSelect.superclass.onDestroy.call(this);
    },
    autoSize: function () {
        if (!this.rendered) {
            return this;
        }
        if (!this.metrics) {
            this.metrics = Ext.util.TextMetrics.createInstance(this.el);
        }
        var el = this.el,
            v = el.dom.value,
            d = document.createElement('div');

        if (v === "" && this.emptyText && this.items.getCount() < 1) {
            v = this.emptyText;
        }
        d.appendChild(document.createTextNode(v));
        v = d.innerHTML;
        d = null;
        v += "&#160;";
        var w = Math.max(this.metrics.getWidth(v) + 24, 24);
        if (typeof this._width != 'undefined') {
            w = Math.min(this._width, w);
        }
        this.el.setWidth(w);

        if (Ext.isIE) {
            this.el.dom.style.top = '0';
        }
        return this;
    },
    doQuery: function (q, forceAll, valuesQuery, forcedAdd) {
        q = Ext.isEmpty(q) ? '' : q;
        var qe = {
            query: q,
            forceAll: forceAll,
            combo: this,
            cancel: false
        };
        if (this.fireEvent('beforequery', qe) === false || qe.cancel) {
            return false;
        }
        q = qe.query;
        forceAll = qe.forceAll;
        if (forceAll === true || (q.length >= this.minChars) || valuesQuery && !Ext.isEmpty(q)) {
            if (this.lastQuery !== q || forcedAdd) {
                this.lastQuery = q;
                if (this.mode == 'local') {
                    this.selectedIndex = -1;
                    if (forceAll) {
                        this.store.clearFilter();
                    } else {
                        this.store.filter(this.displayField, q);
                    }
                    this.onLoad();
                } else {

                    this.store.baseParams[this.queryParam] = q;
                    this.store.baseParams[this.queryValuesIndicator] = valuesQuery;
                    this.store.load({
                        params: this.getParams(q)
                    });
                    if (!forcedAdd) {
                        this.expand();
                    }
                }
            } else {
                this.selectedIndex = -1;
                this.onLoad();
            }
        }
    }
});
Ext.reg('superboxselect', Ext.ux.form.SuperBoxSelect);
/*
 * @private
 */
Ext.ux.form.SuperBoxSelectItem = function (config) {
    Ext.apply(this, config);
    Ext.ux.form.SuperBoxSelectItem.superclass.constructor.call(this);
};
/*
 * @private
 */
Ext.ux.form.SuperBoxSelectItem = Ext.extend(Ext.ux.form.SuperBoxSelectItem, Ext.Component, {
    initComponent: function () {
        Ext.ux.form.SuperBoxSelectItem.superclass.initComponent.call(this);
    },
    onElClick: function (e) {
        var o = this.owner;
        o.clearCurrentFocus().collapse();
        if (o.navigateItemsWithTab) {
            this.focus();
        } else {
            o.el.dom.focus();
            var that = this;
            (function () {
                this.onLnkFocus();
                o.currentFocus = this;
            }).defer(10, this);
        }
    },

    onLnkClick: function (e) {
        if (e) {
            e.stopEvent();
        }
        this.preDestroy();
        if (!this.owner.navigateItemsWithTab) {
            this.owner.el.focus();
        }
    },
    onLnkFocus: function () {
        this.el.addClass("x-superboxselect-item-focus");
        this.owner.outerWrapEl.addClass("x-form-focus");
    },

    onLnkBlur: function () {
        this.el.removeClass("x-superboxselect-item-focus");
        this.owner.outerWrapEl.removeClass("x-form-focus");
    },

    enableElListeners: function () {
        this.el.on('click', this.onElClick, this, {
            stopEvent: true
        });

        this.el.addClassOnOver('x-superboxselect-item x-superboxselect-item-hover');
    },

    enableLnkListeners: function () {
        this.lnk.on({
            click: this.onLnkClick,
            focus: this.onLnkFocus,
            blur: this.onLnkBlur,
            scope: this
        });
    },

    enableAllListeners: function () {
        this.enableElListeners();
        this.enableLnkListeners();
    },
    disableAllListeners: function () {
        this.el.removeAllListeners();
        this.lnk.un('click', this.onLnkClick, this);
        this.lnk.un('focus', this.onLnkFocus, this);
        this.lnk.un('blur', this.onLnkBlur, this);
    },
    onRender: function (ct, position) {

        Ext.ux.form.SuperBoxSelectItem.superclass.onRender.call(this, ct, position);

        var el = this.el;
        if (el) {
            el.remove();
        }

        this.el = el = ct.createChild({
            tag: 'li'
        }, ct.last());
        el.addClass('x-superboxselect-item');

        var btnEl = this.owner.navigateItemsWithTab ? (Ext.isSafari ? 'button' : 'a') : 'span';
        var itemKey = this.key;

        Ext.apply(el, {
            focus: function () {
                var c = this.down(btnEl + '.x-superboxselect-item-close');
                if (c) {
                    c.focus();
                }
            },
            preDestroy: function () {
                this.preDestroy();
            }.createDelegate(this)
        });

        this.enableElListeners();

        el.update(this.caption);

        var cfg = {
            tag: btnEl,
            'class': 'x-superboxselect-item-close',
            tabIndex: this.owner.navigateItemsWithTab ? '0' : '-1'
        };
        if (btnEl === 'a') {
            cfg.href = '#';
        }
        this.lnk = el.createChild(cfg);


        if (!this.disabled) {
            this.enableLnkListeners();
        } else {
            this.disableAllListeners();
        }

        this.on({
            disable: this.disableAllListeners,
            enable: this.enableAllListeners,
            scope: this
        });

        this.setupKeyMap();
    },
    setupKeyMap: function () {
        this.keyMap = new Ext.KeyMap(this.lnk, [{
            key: [
            Ext.EventObject.BACKSPACE,
            Ext.EventObject.DELETE,
            Ext.EventObject.SPACE],
            fn: this.preDestroy,
            scope: this
        }, {
            key: [
            Ext.EventObject.RIGHT,
            Ext.EventObject.DOWN],
            fn: function () {
                this.moveFocus('right');
            },
            scope: this
        }, {
            key: [Ext.EventObject.LEFT, Ext.EventObject.UP],
            fn: function () {
                this.moveFocus('left');
            },
            scope: this
        }, {
            key: [Ext.EventObject.HOME],
            fn: function () {
                var l = this.owner.items.get(0).el.focus();
                if (l) {
                    l.el.focus();
                }
            },
            scope: this
        }, {
            key: [Ext.EventObject.END],
            fn: function () {
                this.owner.el.focus();
            },
            scope: this
        }, {
            key: Ext.EventObject.ENTER,
            fn: function () {}
        }]);
        this.keyMap.stopEvent = true;
    },
    moveFocus: function (dir) {
        var el = this.el[dir == 'left' ? 'prev' : 'next']() || this.owner.el;

        el.focus.defer(100, el);
    },

    preDestroy: function (supressEffect) {
        if (this.fireEvent('remove', this) === false) {
            return;
        }
        var actionDestroy = function () {
                if (this.owner.navigateItemsWithTab) {
                    this.moveFocus('right');
                }
                this.hidden.remove();
                this.hidden = null;
                this.destroy();
            };

        if (supressEffect) {
            actionDestroy.call(this);
        } else {
            this.el.hide({
                duration: 0.2,
                callback: actionDestroy,
                scope: this
            });
        }
        return this;
    },
    kill: function () {
        this.hidden.remove();
        this.hidden = null;
        this.purgeListeners();
        this.destroy();
    },
    onDisable: function () {
        if (this.hidden) {
            this.hidden.dom.setAttribute('disabled', 'disabled');
        }
        this.keyMap.disable();
        Ext.ux.form.SuperBoxSelectItem.superclass.onDisable.call(this);
    },
    onEnable: function () {
        if (this.hidden) {
            this.hidden.dom.removeAttribute('disabled');
        }
        this.keyMap.enable();
        Ext.ux.form.SuperBoxSelectItem.superclass.onEnable.call(this);
    },
    onDestroy: function () {
        Ext.destroy(
        this.lnk,
        this.el);

        Ext.ux.form.SuperBoxSelectItem.superclass.onDestroy.call(this);
    }
});

// Namespace
Ext.ns("SYNOCOMMUNITY.Subliminal");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.Subliminal.AppInstance", category, element)
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/subliminal/subliminal.cgi/direct/router",
    "namespace": "SYNOCOMMUNITY.Subliminal.Remote",
    "type": "remoting",
    "actions": {
        "Subliminal": [{
            "name": "load",
            "len": 0
        }, {
            "formHandler": true,
            "name": "save",
            "len": 4
        }, {
            "name": "scan",
            "len": 0
        }],
        "Directories": [{
            "name": "read",
            "len": 0
        }, {
            "name": "create",
            "len": 1
        }, {
            "name": "update",
            "len": 1
        }, {
            "name": "destroy",
            "len": 1
        }, {
            "name": "scan",
            "len": 1
        }]
    }
});

// Fix for RadioGroup reset bug
Ext.form.RadioGroup.override({
    reset: function () {
        if (this.originalValue) {
            this.setValue(this.originalValue.inputValue);
        } else {
            this.eachItem(function (c) {
                if (c.reset) {
                    c.reset();
                }
            });
        }

        (function () {
            this.clearInvalid();
        }).defer(50, this);
    },
    isDirty: function () {
        if (this.disabled || !this.rendered) {
            return false;
        }
        return String(this.getValue().inputValue) !== String(this.originalValue.inputValue);
    }
});

// Const
SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT = 480;
SYNOCOMMUNITY.Subliminal.MAIN_WIDTH = 750;
SYNOCOMMUNITY.Subliminal.LIST_WIDTH = 210;

// Application
SYNOCOMMUNITY.Subliminal.AppInstance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName: "SYNOCOMMUNITY.Subliminal.AppWindow",
    constructor: function () {
        SYNOCOMMUNITY.Subliminal.AppInstance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SYNOCOMMUNITY.Subliminal.AppWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,
    mainPanel: null,
    constructor: function (config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SYNOCOMMUNITY.Subliminal.MainPanel({
            owner: this
        });
        config = Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: SYNOCOMMUNITY.Subliminal.MAIN_WIDTH,
            height: SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT,
            layout: "fit",
            border: false,
            cls: "synocommunity-subliminal",
            items: [this.mainPanel]
        }, config);
        SYNOCOMMUNITY.Subliminal.AppWindow.superclass.constructor.call(this, config);
    },
    onOpen: function (a) {
        SYNOCOMMUNITY.Subliminal.AppWindow.superclass.onOpen.call(this, a);
        this.mainPanel.onActivate();
    },
    onRequest: function (a) {
        SYNOCOMMUNITY.Subliminal.AppWindow.superclass.onRequest.call(this, a);
    },
    onClose: function () {
        if (SYNOCOMMUNITY.Subliminal.AppWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            this.mainPanel.onDeactivate();
            return true;
        }
        return false;
    },
    setStatus: function (status) {
        status = status || {};
        var toolbar = this.mainPanel.cardPanel.layout.activeItem.getFooterToolbar();
        if (toolbar && Ext.isFunction(toolbar.setStatus)) {
            toolbar.setStatus(status)
        } else {
            this.getMsgBox().alert("Message", status.text)
        }
    }
});

// Main panel
SYNOCOMMUNITY.Subliminal.MainPanel = Ext.extend(Ext.Panel, {
    listPanel: null,
    cardPanel: null,
    constructor: function (config) {
        this.owner = config.owner;
        var a = new SYNOCOMMUNITY.Subliminal.ListView({
            module: this
        });
        this.listPanel = new Ext.Panel({
            region: "west",
            width: SYNOCOMMUNITY.Subliminal.LIST_WIDTH,
            height: SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT,
            cls: "synocommunity-subliminal-list",
            items: [a],
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            },
            onActivate: function (panel) {
                a.onActivate()
            }
        });
        this.listView = a;
        this.curHeight = SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT;
        this.cardPanel = new SYNOCOMMUNITY.Subliminal.MainCardPanel({
            module: this,
            owner: config.owner,
            itemId: "grid",
            region: "center"
        });
        this.id_panel = [
            ["parameters", this.cardPanel.PanelParameters],
            ["directories", this.cardPanel.PanelDirectories]
        ];
        SYNOCOMMUNITY.Subliminal.MainPanel.superclass.constructor.call(this, {
            border: false,
            layout: "border",
            height: SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT,
            monitorResize: true,
            items: [this.listPanel, this.cardPanel]
        });
    },
    onActivate: function (panel) {
        if (!this.isVisible()) {
            return
        }
        this.listPanel.onActivate(panel);
        this.cardPanel.onActivate(panel);
    },
    onDeactivate: function (panel) {
        if (!this.rendered) {
            return
        }
        this.cardPanel.onDeactivate(panel);
    },
    doSwitchPanel: function (id_panel) {
        var c = this.cardPanel.getLayout();
        c.setActiveItem(id_panel);
        var b;
        for (b = 0; b < this.id_panel.length; b++) {
            var a = this.id_panel[b][1];
            if (id_panel === this.id_panel[b][0]) {
                a.onActivate();
                break
            }
        }
    },
    getPanelHeight: function (id_panel) {
        return SYNOCOMMUNITY.Subliminal.DEFAULT_HEIGHT
    },
    isPanelDirty: function (c) {
        var b;
        for (b = 0; b < this.id_panel.length; b++) {
            if (c === this.id_panel[b][0]) {
                var a = this.id_panel[b][1];
                if ("undefined" === typeof a.checkDirty) {
                    return false
                }
                if (true == a.checkDirty()) {
                    return true
                }
                break
            }
        }
        return false
    },
    panelDeactivate: function (c) {
        for (var b = 0; b < this.id_panel.length; b++) {
            if (c === this.id_panel[b][0]) {
                var a = this.id_panel[b][1];
                if ("undefined" === typeof a.onDeactivate) {
                    return
                }
                a.onDeactivate();
                return
            }
        }
        return
    },
    switchPanel: function (f) {
        var c = this.cardPanel.getLayout();
        var b = c.activeItem.itemId;
        if (f === b) {
            return
        }
        if (Ext.isIE) {
            this.doSwitchPanel(f);
            return
        }
        var a = this.getPanelHeight(f);
        if (this.curHeight == a) {
            this.doSwitchPanel(f);
            return
        }
        this.owner.el.disableShadow();
        var d = this.owner.body;
        var e = function () {
                d.clearOpacity();
                this.owner.getEl().setHeight("auto");
                d.setHeight("auto");
                this.owner.setHeight(a);
                this.owner.el.enableShadow();
                this.owner.syncShadow();
                this.doSwitchPanel(f)
            };
        d.shift({
            height: a - 54,
            duration: 0.3,
            opacity: 0.1,
            scope: this,
            callback: e
        });
        this.curHeight = a
    }
});

// List view
SYNOCOMMUNITY.Subliminal.ListView = Ext.extend(Ext.list.ListView, {
    constructor: function (config) {
        var store = new Ext.data.JsonStore({
            data: {
                items: [{
                    title: _V("ui", "console"),
                    id: "console_title"
                }, {
                    title: _V("ui", "parameters"),
                    id: "parameters"
                }, {
                    title: _V("ui", "directories"),
                    id: "directories"
                }]
            },
            autoLoad: true,
            root: "items",
            fields: ["title", "id"]
        });
        config = Ext.apply({
            cls: "synocommunity-subliminal-list",
            padding: 10,
            split: false,
            trackOver: false,
            hideHeaders: true,
            singleSelect: true,
            store: store,
            columns: [{
                dataIndex: "title",
                cls: "synocommunity-subliminal-list-column",
                sortable: false,
                tpl: '<div class="synocommunity-subliminal-list-{id}">{title}</div>'
            }],
            listeners: {
                scope: this,
                beforeclick: this.onBeforeClick,
                selectionchange: this.onListSelect,
                activate: this.onActivate,
                mouseenter: {
                    fn: function (d, e, g) {
                        var f = Ext.get(g);
                        if (f.hasClass(this.selectedClass)) {
                            f.removeClass(this.overClass)
                        }
                        var h = d.getRecord(g).get("id");
                        if (h === "console_title") {
                            f.removeClass(this.overClass)
                        }
                    }
                }
            }
        }, config);
        this.addEvents("onbeforeclick");
        SYNOCOMMUNITY.Subliminal.ListView.superclass.constructor.call(this, config)
    },
    onBeforeClick: function (c, d, f, b) {
        var g = c.getRecord(f);
        var h = g.get("id");
        if (h === "console_title") {
            return false
        }
        if (false == this.fireEvent("onbeforeclick", this, d, f, b)) {
            return false
        }
        var e = this.module.cardPanel.getLayout();
        var a = e.activeItem.itemId;
        if (h === a) {
            return false
        }
        if (this.module.isPanelDirty(a)) {
            this.module.cardPanel.owner.getMsgBox().confirm(_T("app", "app_name"), _T("common", "confirm_lostchange"),
            function (i) {
                if ("yes" === i) {
                    this.module.panelDeactivate(a);
                    this.select(d)
                }
            }, this);
            return false
        }
        this.module.panelDeactivate(a);
        return true
    },
    onListSelect: function (b, a) {
        var c = this.getRecord(a[0]);
        this.module.switchPanel(c.get("id"))
    },
    onActivate: function (panel) {
        var a = this.getSelectedRecords()[0];
        if (!a) {
            this.select(1)
        }
    }
});

// Card panel
SYNOCOMMUNITY.Subliminal.MainCardPanel = Ext.extend(Ext.Panel, {
    PanelParameters: null,
    constructor: function (config) {
        this.owner = config.owner;
        this.module = config.module;
        this.PanelParameters = new SYNOCOMMUNITY.Subliminal.PanelParameters({
            owner: this.owner
        });
        this.PanelDirectories = new SYNOCOMMUNITY.Subliminal.PanelDirectories({
            owner: this.owner
        });
        config = Ext.apply({
            activeItem: 0,
            layout: "card",
            items: [this.PanelParameters, this.PanelDirectories],
            border: false,
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            }
        }, config);
        SYNOCOMMUNITY.Subliminal.MainCardPanel.superclass.constructor.call(this, config)
    },
    onActivate: function (panel) {
        if (this.PanelParameters) {
            this.PanelParameters.onActivate();
        }
    },
    onDeactivate: function (panel) {
        this.PanelParameters.onDeactivate();
    }
});

// FormPanel base
SYNOCOMMUNITY.Subliminal.FormPanel = Ext.extend(Ext.FormPanel, {
    constructor: function (config) {
        config = Ext.apply({
            owner: null,
            items: [],
            padding: "20px 30px 2px 30px",
            border: false,
            header: false,
            trackResetOnLoad: true,
            monitorValid: true,
            fbar: {
                xtype: "statusbar",
                defaultText: "&nbsp;",
                statusAlign: "left",
                buttonAlign: "left",
                hideMode: "visibility",
                items: [{
                    text: _T("common", "commit"),
                    ctCls: "syno-sds-cp-btn",
                    scope: this,
                    handler: this.onApply
                }, {
                    text: _T("common", "reset"),
                    ctCls: "syno-sds-cp-btn",
                    scope: this,
                    handler: this.onReset
                }]
            }
        }, config);
        SYNO.LayoutConfig.fill(config);
        SYNOCOMMUNITY.Subliminal.FormPanel.superclass.constructor.call(this, config);
        if (!this.owner instanceof SYNO.SDS.BaseWindow) {
            throw Error("please set the owner window of form");
        }
    },
    onActivate: Ext.emptyFn,
    onDeactivate: Ext.emptyFn,
    onApply: function () {
        if (!this.getForm().isDirty()) {
            this.owner.setStatusError({
                text: _T("error", "nochange_subject"),
                clear: true
            });
            return;
        }
        if (!this.getForm().isValid()) {
            this.owner.setStatusError({
                text: _T("common", "forminvalid"),
                clear: true
            });
            return;
        }
        return true;
    },
    onReset: function () {
        if (!this.getForm().isDirty()) {
            this.getForm().reset();
            return;
        }
        this.owner.getMsgBox().confirm(this.title, _T("common", "confirm_lostchange"),
        function (response) {
            if ("yes" === response) {
                this.getForm().reset();
            }
        }, this);
    }
});

// Parameters panel
SYNOCOMMUNITY.Subliminal.PanelParameters = Ext.extend(SYNOCOMMUNITY.Subliminal.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        config = Ext.apply({
            itemId: "parameters",
            items: [{
                xtype: "fieldset",
                labelWidth: 130,
                title: _V("ui", "general"),
                defaultType: "textfield",
                items: [{
                    xtype: "superboxselect",
                    allowBlank: false,
                    fieldLabel: _V("ui", "languages"),
                    name: "languages",
                    mode: "local",
                    valueField: "code",
                    displayField: "name",
                    store: new Ext.data.ArrayStore({
                        fields: ["code", "name"],
                        data: [
                            ["aar", "Afar"],
                            ["abk", "Abkhazian"],
                            ["ace", "Achinese"],
                            ["ach", "Acoli"],
                            ["ada", "Adangme"],
                            ["ady", "Adyghe"],
                            ["afa", "Afro-Asiatic languages"],
                            ["afh", "Afrihili"],
                            ["afr", "Afrikaans"],
                            ["ain", "Ainu"],
                            ["aka", "Akan"],
                            ["akk", "Akkadian"],
                            ["alb", "Albanian"],
                            ["ale", "Aleut"],
                            ["alg", "Algonquian languages"],
                            ["alt", "Southern Altai"],
                            ["amh", "Amharic"],
                            ["ang", "English, Old (ca.450-1100)"],
                            ["anp", "Angika"],
                            ["apa", "Apache languages"],
                            ["ara", "Arabic"],
                            ["arc", "Official Aramaic (700-300 BCE)"],
                            ["arg", "Aragonese"],
                            ["arm", "Armenian"],
                            ["arn", "Mapudungun"],
                            ["arp", "Arapaho"],
                            ["art", "Artificial languages"],
                            ["arw", "Arawak"],
                            ["asm", "Assamese"],
                            ["ast", "Asturian"],
                            ["ath", "Athapascan languages"],
                            ["aus", "Australian languages"],
                            ["ava", "Avaric"],
                            ["ave", "Avestan"],
                            ["awa", "Awadhi"],
                            ["aym", "Aymara"],
                            ["aze", "Azerbaijani"],
                            ["bad", "Banda languages"],
                            ["bai", "Bamileke languages"],
                            ["bak", "Bashkir"],
                            ["bal", "Baluchi"],
                            ["bam", "Bambara"],
                            ["ban", "Balinese"],
                            ["baq", "Basque"],
                            ["bas", "Basa"],
                            ["bat", "Baltic languages"],
                            ["bej", "Beja"],
                            ["bel", "Belarusian"],
                            ["bem", "Bemba"],
                            ["ben", "Bengali"],
                            ["ber", "Berber languages"],
                            ["bho", "Bhojpuri"],
                            ["bih", "Bihari languages"],
                            ["bik", "Bikol"],
                            ["bin", "Bini"],
                            ["bis", "Bislama"],
                            ["bla", "Siksika"],
                            ["bnt", "Bantu (Other)"],
                            ["bos", "Bosnian"],
                            ["bra", "Braj"],
                            ["bre", "Breton"],
                            ["btk", "Batak languages"],
                            ["bua", "Buriat"],
                            ["bug", "Buginese"],
                            ["bul", "Bulgarian"],
                            ["bur", "Burmese"],
                            ["byn", "Blin"],
                            ["cad", "Caddo"],
                            ["cai", "Central American Indian languages"],
                            ["car", "Galibi Carib"],
                            ["cat", "Catalan"],
                            ["cau", "Caucasian languages"],
                            ["ceb", "Cebuano"],
                            ["cel", "Celtic languages"],
                            ["cha", "Chamorro"],
                            ["chb", "Chibcha"],
                            ["che", "Chechen"],
                            ["chg", "Chagatai"],
                            ["chi", "Chinese"],
                            ["chk", "Chuukese"],
                            ["chm", "Mari"],
                            ["chn", "Chinook jargon"],
                            ["cho", "Choctaw"],
                            ["chp", "Chipewyan"],
                            ["chr", "Cherokee"],
                            ["chu", "Church Slavic"],
                            ["chv", "Chuvash"],
                            ["chy", "Cheyenne"],
                            ["cmc", "Chamic languages"],
                            ["cop", "Coptic"],
                            ["cor", "Cornish"],
                            ["cos", "Corsican"],
                            ["cpe", "Creoles and pidgins, English based"],
                            ["cpf", "Creoles and pidgins, French-based "],
                            ["cpp", "Creoles and pidgins, Portuguese-based "],
                            ["cre", "Cree"],
                            ["crh", "Crimean Tatar"],
                            ["crp", "Creoles and pidgins "],
                            ["csb", "Kashubian"],
                            ["cus", "Cushitic languages"],
                            ["cze", "Czech"],
                            ["dak", "Dakota"],
                            ["dan", "Danish"],
                            ["dar", "Dargwa"],
                            ["day", "Land Dayak languages"],
                            ["del", "Delaware"],
                            ["den", "Slave (Athapascan)"],
                            ["dgr", "Dogrib"],
                            ["din", "Dinka"],
                            ["div", "Divehi"],
                            ["doi", "Dogri"],
                            ["dra", "Dravidian languages"],
                            ["dsb", "Lower Sorbian"],
                            ["dua", "Duala"],
                            ["dum", "Dutch, Middle (ca.1050-1350)"],
                            ["dut", "Dutch"],
                            ["dyu", "Dyula"],
                            ["dzo", "Dzongkha"],
                            ["efi", "Efik"],
                            ["egy", "Egyptian (Ancient)"],
                            ["eka", "Ekajuk"],
                            ["elx", "Elamite"],
                            ["eng", "English"],
                            ["enm", "English, Middle (1100-1500)"],
                            ["epo", "Esperanto"],
                            ["est", "Estonian"],
                            ["ewe", "Ewe"],
                            ["ewo", "Ewondo"],
                            ["fan", "Fang"],
                            ["fao", "Faroese"],
                            ["fat", "Fanti"],
                            ["fij", "Fijian"],
                            ["fil", "Filipino"],
                            ["fin", "Finnish"],
                            ["fiu", "Finno-Ugrian languages"],
                            ["fon", "Fon"],
                            ["fre", "French"],
                            ["frm", "French, Middle (ca.1400-1600)"],
                            ["fro", "French, Old (842-ca.1400)"],
                            ["frr", "Northern Frisian"],
                            ["frs", "Eastern Frisian"],
                            ["fry", "Western Frisian"],
                            ["ful", "Fulah"],
                            ["fur", "Friulian"],
                            ["gaa", "Ga"],
                            ["gay", "Gayo"],
                            ["gba", "Gbaya"],
                            ["gem", "Germanic languages"],
                            ["geo", "Georgian"],
                            ["ger", "German"],
                            ["gez", "Geez"],
                            ["gil", "Gilbertese"],
                            ["gla", "Gaelic"],
                            ["gle", "Irish"],
                            ["glg", "Galician"],
                            ["glv", "Manx"],
                            ["gmh", "German, Middle High (ca.1050-1500)"],
                            ["goh", "German, Old High (ca.750-1050)"],
                            ["gon", "Gondi"],
                            ["gor", "Gorontalo"],
                            ["got", "Gothic"],
                            ["grb", "Grebo"],
                            ["grc", "Greek, Ancient (to 1453)"],
                            ["gre", "Greek, Modern (1453-)"],
                            ["grn", "Guarani"],
                            ["gsw", "Swiss German"],
                            ["guj", "Gujarati"],
                            ["gwi", "Gwich'in"],
                            ["hai", "Haida"],
                            ["hat", "Haitian"],
                            ["hau", "Hausa"],
                            ["haw", "Hawaiian"],
                            ["heb", "Hebrew"],
                            ["her", "Herero"],
                            ["hil", "Hiligaynon"],
                            ["him", "Himachali languages"],
                            ["hin", "Hindi"],
                            ["hit", "Hittite"],
                            ["hmn", "Hmong"],
                            ["hmo", "Hiri Motu"],
                            ["hrv", "Croatian"],
                            ["hsb", "Upper Sorbian"],
                            ["hun", "Hungarian"],
                            ["hup", "Hupa"],
                            ["iba", "Iban"],
                            ["ibo", "Igbo"],
                            ["ice", "Icelandic"],
                            ["ido", "Ido"],
                            ["iii", "Sichuan Yi"],
                            ["ijo", "Ijo languages"],
                            ["iku", "Inuktitut"],
                            ["ile", "Interlingue"],
                            ["ilo", "Iloko"],
                            ["ina", "Interlingua (International Auxiliary Language Association)"],
                            ["inc", "Indic languages"],
                            ["ind", "Indonesian"],
                            ["ine", "Indo-European languages"],
                            ["inh", "Ingush"],
                            ["ipk", "Inupiaq"],
                            ["ira", "Iranian languages"],
                            ["iro", "Iroquoian languages"],
                            ["ita", "Italian"],
                            ["jav", "Javanese"],
                            ["jbo", "Lojban"],
                            ["jpn", "Japanese"],
                            ["jpr", "Judeo-Persian"],
                            ["jrb", "Judeo-Arabic"],
                            ["kaa", "Kara-Kalpak"],
                            ["kab", "Kabyle"],
                            ["kac", "Kachin"],
                            ["kal", "Kalaallisut"],
                            ["kam", "Kamba"],
                            ["kan", "Kannada"],
                            ["kar", "Karen languages"],
                            ["kas", "Kashmiri"],
                            ["kau", "Kanuri"],
                            ["kaw", "Kawi"],
                            ["kaz", "Kazakh"],
                            ["kbd", "Kabardian"],
                            ["kha", "Khasi"],
                            ["khi", "Khoisan languages"],
                            ["khm", "Central Khmer"],
                            ["kho", "Khotanese"],
                            ["kik", "Kikuyu"],
                            ["kin", "Kinyarwanda"],
                            ["kir", "Kirghiz"],
                            ["kmb", "Kimbundu"],
                            ["kok", "Konkani"],
                            ["kom", "Komi"],
                            ["kon", "Kongo"],
                            ["kor", "Korean"],
                            ["kos", "Kosraean"],
                            ["kpe", "Kpelle"],
                            ["krc", "Karachay-Balkar"],
                            ["krl", "Karelian"],
                            ["kro", "Kru languages"],
                            ["kru", "Kurukh"],
                            ["kua", "Kuanyama"],
                            ["kum", "Kumyk"],
                            ["kur", "Kurdish"],
                            ["kut", "Kutenai"],
                            ["lad", "Ladino"],
                            ["lah", "Lahnda"],
                            ["lam", "Lamba"],
                            ["lao", "Lao"],
                            ["lat", "Latin"],
                            ["lav", "Latvian"],
                            ["lez", "Lezghian"],
                            ["lim", "Limburgan"],
                            ["lin", "Lingala"],
                            ["lit", "Lithuanian"],
                            ["lol", "Mongo"],
                            ["loz", "Lozi"],
                            ["ltz", "Luxembourgish"],
                            ["lua", "Luba-Lulua"],
                            ["lub", "Luba-Katanga"],
                            ["lug", "Ganda"],
                            ["lui", "Luiseno"],
                            ["lun", "Lunda"],
                            ["luo", "Luo (Kenya and Tanzania)"],
                            ["lus", "Lushai"],
                            ["mac", "Macedonian"],
                            ["mad", "Madurese"],
                            ["mag", "Magahi"],
                            ["mah", "Marshallese"],
                            ["mai", "Maithili"],
                            ["mak", "Makasar"],
                            ["mal", "Malayalam"],
                            ["man", "Mandingo"],
                            ["mao", "Maori"],
                            ["map", "Austronesian languages"],
                            ["mar", "Marathi"],
                            ["mas", "Masai"],
                            ["may", "Malay"],
                            ["mdf", "Moksha"],
                            ["mdr", "Mandar"],
                            ["men", "Mende"],
                            ["mga", "Irish, Middle (900-1200)"],
                            ["mic", "Mi'kmaq"],
                            ["min", "Minangkabau"],
                            ["mkh", "Mon-Khmer languages"],
                            ["mlg", "Malagasy"],
                            ["mlt", "Maltese"],
                            ["mnc", "Manchu"],
                            ["mni", "Manipuri"],
                            ["mno", "Manobo languages"],
                            ["moh", "Mohawk"],
                            ["mon", "Mongolian"],
                            ["mos", "Mossi"],
                            ["mun", "Munda languages"],
                            ["mus", "Creek"],
                            ["mwl", "Mirandese"],
                            ["mwr", "Marwari"],
                            ["myn", "Mayan languages"],
                            ["myv", "Erzya"],
                            ["nah", "Nahuatl languages"],
                            ["nai", "North American Indian languages"],
                            ["nap", "Neapolitan"],
                            ["nau", "Nauru"],
                            ["nav", "Navajo"],
                            ["nbl", "Ndebele, South"],
                            ["nde", "Ndebele, North"],
                            ["ndo", "Ndonga"],
                            ["nds", "Low German"],
                            ["nep", "Nepali"],
                            ["new", "Nepal Bhasa"],
                            ["nia", "Nias"],
                            ["nic", "Niger-Kordofanian languages"],
                            ["niu", "Niuean"],
                            ["nno", "Norwegian Nynorsk"],
                            ["nob", "Bokmål, Norwegian"],
                            ["nog", "Nogai"],
                            ["non", "Norse, Old"],
                            ["nor", "Norwegian"],
                            ["nqo", "N'Ko"],
                            ["nso", "Pedi"],
                            ["nub", "Nubian languages"],
                            ["nwc", "Classical Newari"],
                            ["nya", "Chichewa"],
                            ["nym", "Nyamwezi"],
                            ["nyn", "Nyankole"],
                            ["nyo", "Nyoro"],
                            ["nzi", "Nzima"],
                            ["oci", "Occitan (post 1500)"],
                            ["oji", "Ojibwa"],
                            ["ori", "Oriya"],
                            ["orm", "Oromo"],
                            ["osa", "Osage"],
                            ["oss", "Ossetian"],
                            ["ota", "Turkish, Ottoman (1500-1928)"],
                            ["oto", "Otomian languages"],
                            ["paa", "Papuan languages"],
                            ["pag", "Pangasinan"],
                            ["pal", "Pahlavi"],
                            ["pam", "Pampanga"],
                            ["pan", "Panjabi"],
                            ["pap", "Papiamento"],
                            ["pau", "Palauan"],
                            ["peo", "Persian, Old (ca.600-400 B.C.)"],
                            ["per", "Persian"],
                            ["phi", "Philippine languages"],
                            ["phn", "Phoenician"],
                            ["pli", "Pali"],
                            ["pol", "Polish"],
                            ["pon", "Pohnpeian"],
                            ["por", "Portuguese"],
                            ["pra", "Prakrit languages"],
                            ["pro", "Provençal, Old (to 1500)"],
                            ["pus", "Pushto"],
                            ["que", "Quechua"],
                            ["raj", "Rajasthani"],
                            ["rap", "Rapanui"],
                            ["rar", "Rarotongan"],
                            ["roa", "Romance languages"],
                            ["roh", "Romansh"],
                            ["rom", "Romany"],
                            ["rum", "Romanian"],
                            ["run", "Rundi"],
                            ["rup", "Aromanian"],
                            ["rus", "Russian"],
                            ["sad", "Sandawe"],
                            ["sag", "Sango"],
                            ["sah", "Yakut"],
                            ["sai", "South American Indian (Other)"],
                            ["sal", "Salishan languages"],
                            ["sam", "Samaritan Aramaic"],
                            ["san", "Sanskrit"],
                            ["sas", "Sasak"],
                            ["sat", "Santali"],
                            ["scn", "Sicilian"],
                            ["sco", "Scots"],
                            ["sel", "Selkup"],
                            ["sem", "Semitic languages"],
                            ["sga", "Irish, Old (to 900)"],
                            ["sgn", "Sign Languages"],
                            ["shn", "Shan"],
                            ["sid", "Sidamo"],
                            ["sin", "Sinhala"],
                            ["sio", "Siouan languages"],
                            ["sit", "Sino-Tibetan languages"],
                            ["sla", "Slavic languages"],
                            ["slo", "Slovak"],
                            ["slv", "Slovenian"],
                            ["sma", "Southern Sami"],
                            ["sme", "Northern Sami"],
                            ["smi", "Sami languages"],
                            ["smj", "Lule Sami"],
                            ["smn", "Inari Sami"],
                            ["smo", "Samoan"],
                            ["sms", "Skolt Sami"],
                            ["sna", "Shona"],
                            ["snd", "Sindhi"],
                            ["snk", "Soninke"],
                            ["sog", "Sogdian"],
                            ["som", "Somali"],
                            ["son", "Songhai languages"],
                            ["sot", "Sotho, Southern"],
                            ["spa", "Spanish"],
                            ["srd", "Sardinian"],
                            ["srn", "Sranan Tongo"],
                            ["srp", "Serbian"],
                            ["srr", "Serer"],
                            ["ssa", "Nilo-Saharan languages"],
                            ["ssw", "Swati"],
                            ["suk", "Sukuma"],
                            ["sun", "Sundanese"],
                            ["sus", "Susu"],
                            ["sux", "Sumerian"],
                            ["swa", "Swahili"],
                            ["swe", "Swedish"],
                            ["syc", "Classical Syriac"],
                            ["syr", "Syriac"],
                            ["tah", "Tahitian"],
                            ["tai", "Tai languages"],
                            ["tam", "Tamil"],
                            ["tat", "Tatar"],
                            ["tel", "Telugu"],
                            ["tem", "Timne"],
                            ["ter", "Tereno"],
                            ["tet", "Tetum"],
                            ["tgk", "Tajik"],
                            ["tgl", "Tagalog"],
                            ["tha", "Thai"],
                            ["tib", "Tibetan"],
                            ["tig", "Tigre"],
                            ["tir", "Tigrinya"],
                            ["tiv", "Tiv"],
                            ["tkl", "Tokelau"],
                            ["tlh", "Klingon"],
                            ["tli", "Tlingit"],
                            ["tmh", "Tamashek"],
                            ["tog", "Tonga (Nyasa)"],
                            ["ton", "Tonga (Tonga Islands)"],
                            ["tpi", "Tok Pisin"],
                            ["tsi", "Tsimshian"],
                            ["tsn", "Tswana"],
                            ["tso", "Tsonga"],
                            ["tuk", "Turkmen"],
                            ["tum", "Tumbuka"],
                            ["tup", "Tupi languages"],
                            ["tur", "Turkish"],
                            ["tut", "Altaic languages"],
                            ["tvl", "Tuvalu"],
                            ["twi", "Twi"],
                            ["tyv", "Tuvinian"],
                            ["udm", "Udmurt"],
                            ["uga", "Ugaritic"],
                            ["uig", "Uighur"],
                            ["ukr", "Ukrainian"],
                            ["umb", "Umbundu"],
                            ["urd", "Urdu"],
                            ["uzb", "Uzbek"],
                            ["vai", "Vai"],
                            ["ven", "Venda"],
                            ["vie", "Vietnamese"],
                            ["vol", "Volapük"],
                            ["vot", "Votic"],
                            ["wak", "Wakashan languages"],
                            ["wal", "Walamo"],
                            ["war", "Waray"],
                            ["was", "Washo"],
                            ["wel", "Welsh"],
                            ["wen", "Sorbian languages"],
                            ["wln", "Walloon"],
                            ["wol", "Wolof"],
                            ["xal", "Kalmyk"],
                            ["xho", "Xhosa"],
                            ["yao", "Yao"],
                            ["yap", "Yapese"],
                            ["yid", "Yiddish"],
                            ["yor", "Yoruba"],
                            ["ypk", "Yupik languages"],
                            ["zap", "Zapotec"],
                            ["zbl", "Blissymbols"],
                            ["zen", "Zenaga"],
                            ["zha", "Zhuang"],
                            ["znd", "Zande languages"],
                            ["zul", "Zulu"],
                            ["zun", "Zuni"],
                            ["zza", "Zaza"],
                            ["por-BR", "Portuguese (Brazil)"]
                        ],
                        sortInfo: {
                            field: "name",
                            direction: "ASC"
                        }
                    })
                }, {
                    xtype: "superboxselect",
                    allowBlank: false,
                    fieldLabel: _V("ui", "services"),
                    name: "services",
                    mode: "local",
                    valueField: "name",
                    displayField: "display_name",
                    store: new Ext.data.ArrayStore({
                        fields: ["display_name", "name"],
                        data: [
                            ["OpenSubtitles", "opensubtitles"],
                            ["BierDopje", "bierdopje"],
                            ["TheSubDB", "thesubdb"],
                            ["SubsWiki", "subswiki"],
                            ["Subtitulos", "subtitulos"],
                            ["Addic7ed", "addic7ed"],
                            ["TvSubtitles", "tvsubtitles"]
                        ]
                    })
                }, {
                    xtype: "checkbox",
                    fieldLabel: _V("ui", "multi"),
                    name: "multi"
                }, {
                    xtype: "numberfield",
                    fieldLabel: _V("ui", "max_depth"),
                    name: "max_depth",
                    allowBlank: false,
                    allowDecimals: false,
                    allowNegative: false,
                    minValue: 1,
                    maxValue: 8
                }, {
                    xtype: "checkbox",
                    fieldLabel: _V("ui", "dsm_notifications"),
                    name: "dsm_notifications"
                }]
            }, {
                xtype: "fieldset",
                labelWidth: 130,
                title: _V("ui", "task"),
                defaultType: "textfield",
                items: [{
                    xtype: "checkbox",
                    fieldLabel: _V("ui", "enable"),
                    name: "task"
                }, {
                    xtype: "numberfield",
                    fieldLabel: _V("ui", "age"),
                    name: "age",
                    allowBlank: false,
                    allowDecimals: false,
                    allowNegative: false,
                    minValue: 3,
                    maxValue: 30
                }, {
                    xtype: "numberfield",
                    fieldLabel: _V("ui", "hour"),
                    name: "hour",
                    allowBlank: false,
                    allowDecimals: false,
                    allowNegative: false,
                    minValue: 0,
                    maxValue: 23
                }, {
                    xtype: "numberfield",
                    fieldLabel: _V("ui", "minute"),
                    name: "minute",
                    allowBlank: false,
                    allowDecimals: false,
                    allowNegative: false,
                    minValue: 0,
                    maxValue: 59
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.Subliminal.Remote.Subliminal.load,
                submit: SYNOCOMMUNITY.Subliminal.Remote.Subliminal.save
            }
        }, config);
        SYNOCOMMUNITY.Subliminal.PanelParameters.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.loaded = true;
            this.getEl().mask(_T("common", "loading"), "x-mask-loading");
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.Subliminal.PanelParameters.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getFieldValues());
            }
        });
    }
});

// Directories panel
SYNOCOMMUNITY.Subliminal.PanelDirectories = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        this.store = new Ext.data.DirectStore({
            autoSave: false,
            fields: ["id", "name", "path"],
            api: {
                read: SYNOCOMMUNITY.Subliminal.Remote.Directories.read,
                create: SYNOCOMMUNITY.Subliminal.Remote.Directories.create,
                update: SYNOCOMMUNITY.Subliminal.Remote.Directories.update,
                destroy: SYNOCOMMUNITY.Subliminal.Remote.Directories.destroy
            },
            idProperty: "id",
            root: "data",
            writer: new Ext.data.JsonWriter({
                encode: false,
                listful: true,
                writeAllFields: true
            })
        });
        config = Ext.apply({
            itemId: "directories",
            border: false,
            store: this.store,
            loadMask: true,
            tbar: {
                items: [{
                    text: _V("ui", "add"),
                    itemId: "add",
                    scope: this,
                    handler: this.onClickAdd
                }, {
                    text: _V("ui", "edit"),
                    itemId: "edit",
                    scope: this,
                    handler: this.onClickEdit
                }, {
                    text: _V("ui", "delete"),
                    itemId: "delete",
                    scope: this,
                    handler: this.onClickDelete
                }, {
                    text: _V("ui", "scan"),
                    itemId: "scan",
                    scope: this,
                    handler: this.onClickScan
                }]
            },
            columns: [{
                header: _V("ui", "name"),
                sortable: true,
                width: 40,
                dataIndex: "name"
            }, {
                header: _V("ui", "path"),
                dataIndex: "path"
            }]
        }, config);
        SYNOCOMMUNITY.Subliminal.PanelDirectories.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.store.load();
            this.loaded = true;
        }
    },
    onClickAdd: function () {
        var editor = new SYNOCOMMUNITY.Subliminal.DirectoryEditorWindow({
            store: this.store,
            title: _V("ui", "directory_add")
        });
        editor.open();
    },
    onClickEdit: function () {
        var editor = new SYNOCOMMUNITY.Subliminal.DirectoryEditorWindow({
            store: this.store,
            record: this.getSelectionModel().getSelected(),
            title: _V("ui", "directory_edit")
        });
        editor.open();
    },
    onClickDelete: function () {
        var records = this.getSelectionModel().getSelections();
        if (records.length != 0) {
            this.store.remove(this.getSelectionModel().getSelections());
            this.store.save();
        }
    },
    onClickScan: function () {
        this.getSelectionModel().each(function (record) {
            SYNOCOMMUNITY.Subliminal.Remote.Directories.scan(record.id);
        });
    },
    onClickRefresh: function () {
        this.store.load();
    }
});

// Directory window
SYNOCOMMUNITY.Subliminal.DirectoryEditorWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    initComponent: function () {
        this.panel = new SYNOCOMMUNITY.Subliminal.PanelDirectoryEditor();
        var config = {
            width: 450,
            height: 180,
            resizable: false,
            layout: "fit",
            items: [this.panel],
            listeners: {
                scope: this,
                afterrender: this.onAfterRender
            },
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "close"),
                scope: this,
                handler: this.onClickClose
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.Subliminal.DirectoryEditorWindow.superclass.initComponent.apply(this, arguments);
    },
    onAfterRender: function () {
        if (this.record) {
            this.panel.loadRecord(this.record);
        }
    },
    onClickApply: function () {
        if (this.record === undefined) {
            var record = new this.store.recordType({
                name: this.panel.getForm().findField("name").getValue(),
                path: this.panel.getForm().findField("path").getValue()
            });
            this.store.add(record);
        } else {
            this.record.beginEdit();
            this.record.set("name", this.panel.getForm().findField("name").getValue());
            this.record.set("path", this.panel.getForm().findField("path").getValue());
            this.record.endEdit();
        }
        this.store.save();
        this.close();
    },
    onClickClose: function () {
        this.close();
    }
});

// Directory panel
SYNOCOMMUNITY.Subliminal.PanelDirectoryEditor = Ext.extend(SYNOCOMMUNITY.Subliminal.FormPanel, {
    initComponent: function () {
        var config = {
            itemId: "directory",
            padding: "15px 15px 2px 15px",
            defaultType: "textfield",
            labelWidth: 130,
            fbar: null,
            defaults: {
                anchor: "-20"
            },
            items: [{
                fieldLabel: _V("ui", "name"),
                name: "name"
            }, {
                xtype: "compositefield",
                fieldLabel: _V("ui", "path"),
                items: [{
                    xtype: "textfield",
                    name: "path",
                    readOnly: true
                }, {
                    xtype: "button",
                    id: "synocommunity-subliminal-browse",
                    text: _V("browser", "browse"),
                    handler: this.onClickBrowse,
                    scope: this
                }]
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.Subliminal.PanelDirectoryEditor.superclass.initComponent.apply(this, arguments);
    },
    loadRecord: function (record) {
        this.getForm().findField("name").setValue(record.data.name);
        this.getForm().findField("path").setValue(record.data.path);
    },
    onClickBrowse: function (button, event) {
        var browser = new SYNOCOMMUNITY.Subliminal.BrowserWindow({});
        browser.mon(browser, "apply",
        function (selectionModel) {
            this.getForm().findField("path").setValue(selectionModel.getSelectedNode().attributes.path);
        }, this);
        browser.open();
    }
});

// Folder browser window
SYNOCOMMUNITY.Subliminal.BrowserWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    initComponent: function () {
        this.panel = new Ext.tree.TreePanel({
            loader: {
                dataUrl: "/webman/modules/FileBrowser/file_share.cgi",
                baseParams: {
                    action: "getshares",
                    needrw: "false",
                    bldisableist: "true"
                }
            },
            autoScroll: true,
            animate: false,
            useArrows: true,
            trackMouseOver: false,
            border: false,
            root: {
                id: "fm_root",
                text: _S("hostname"),
                draggable: false,
                expanded: true,
                allowDrop: false,
                icon: "/webman/modules/FileBrowser/webfm/images/button/my_ds.png",
                cls: "root_node"
            },
            listeners: {
                scope: this,
                beforeload: function () {
                    this.setStatusBusy();
                },
                load: function () {
                    this.clearStatusBusy();
                }
            }
        });
        var config = {
            title: _V("browser", "title"),
            width: 450,
            height: 500,
            layout: "fit",
            items: [this.panel],
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "cancel"),
                scope: this,
                handler: this.onClickCancel
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        this.addEvents("apply", "cancel");
        SYNOCOMMUNITY.Subliminal.BrowserWindow.superclass.initComponent.apply(this, arguments);
    },
    onClickApply: function () {
        this.fireEvent("apply", this.panel.getSelectionModel());
        this.close();
    },
    onClickCancel: function () {
        this.fireEvent("cancel");
        this.close();
    }
});
