(function () {
    var RU_LINE =
        /^\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|Устная заготовка|Итог одной фразой)\s*\(RU\):/i;
    var RU_BULLET = /^\s*[-*]\s+\*\*RU:\*\*/;
    var OTвет = /^\s*[-*]\s+\*\*Ответ\*\*:/;

    function isRuLine(text) {
        return RU_LINE.test(text) || RU_BULLET.test(text) || OTвет.test(text);
    }

    function isInsideLangRu(node) {
        var p = node.parentElement;
        while (p) {
            if (p.classList && p.classList.contains("lang-ru")) return true;
            if (p.classList && p.classList.contains("markdown-section")) return false;
            p = p.parentElement;
        }
        return false;
    }

    function collectRuSiblings(startLi) {
        var items = [startLi];
        var next = startLi.nextElementSibling;
        while (next && next.tagName === "LI" && isRuLine(next.textContent)) {
            items.push(next);
            next = next.nextElementSibling;
        }
        return items;
    }

    function wrapRuBlock(items) {
        if (!items.length) return;
        var parent = items[0].parentElement;
        if (!parent) return;
        var details = document.createElement("details");
        details.className = "lang-ru";
        var summary = document.createElement("summary");
        summary.textContent = "По-русски";
        details.appendChild(summary);
        var ul = document.createElement("ul");
        items.forEach(function (li) {
            ul.appendChild(li);
        });
        details.appendChild(ul);
        parent.insertBefore(details, items[0]);
    }

    function collapseLegacyRuLists(root) {
        var lists = root.querySelectorAll(".markdown-section ul, .markdown-section ol");
        lists.forEach(function (list) {
            if (list.closest(".lang-ru")) return;
            var children = Array.from(list.children).filter(function (c) {
                return c.tagName === "LI";
            });
            var i = 0;
            while (i < children.length) {
                var li = children[i];
                if (isInsideLangRu(li)) {
                    i++;
                    continue;
                }
                if (!isRuLine(li.textContent)) {
                    i++;
                    continue;
                }
                var block = collectRuSiblings(li);
                wrapRuBlock(block);
                children = Array.from(list.children).filter(function (c) {
                    return c.tagName === "LI";
                });
                i = 0;
            }
        });
    }

    function collapseRuHeadings(root) {
        var headings = root.querySelectorAll(".markdown-section h3, .markdown-section h4");
        headings.forEach(function (h) {
            if (h.textContent.trim() !== "RU") return;
            var enHeading = h.previousElementSibling;
            if (!enHeading || enHeading.tagName !== "H3" || enHeading.textContent.trim() !== "EN") {
                return;
            }
            var enBlock = [];
            var node = enHeading.nextElementSibling;
            while (node && node !== h) {
                enBlock.push(node);
                node = node.nextElementSibling;
            }
            var ruBlock = [];
            node = h.nextElementSibling;
            while (node && node.tagName !== "H2" && node.tagName !== "H3" && !(node.tagName === "HR")) {
                if (node.tagName === "H3" && node.textContent.trim() === "EN") break;
                ruBlock.push(node);
                node = node.nextElementSibling;
            }
            if (!ruBlock.length) return;
            var details = document.createElement("details");
            details.className = "lang-ru";
            var summary = document.createElement("summary");
            summary.textContent = "По-русски";
            details.appendChild(summary);
            ruBlock.forEach(function (n) {
                details.appendChild(n);
            });
            h.parentNode.insertBefore(details, h);
            h.remove();
        });
    }

    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = window.$docsify.plugins || [];
    window.$docsify.plugins.push(function (hook) {
        hook.doneEach(function () {
            var root = document.querySelector("#main") || document;
            collapseLegacyRuLists(root);
            collapseRuHeadings(root);
        });
    });
})();
