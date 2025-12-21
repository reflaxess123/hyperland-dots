#!/bin/bash

LOG_FILE="$HOME/.local/share/singbox-traffic.log"

# Direct domains from config
DIRECT_DOMAINS="yandex.ru, ya.ru, *.yandex.net"

get_recent_traffic() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "Нет данных"
        return
    fi

    local direct_list=""
    local proxy_list=""
    local seen_direct=""
    local seen_proxy=""

    # Parse recent connections from debug log
    while IFS= read -r line; do
        # Look for connection lines with domain info
        if [[ "$line" == *"connection"* ]] || [[ "$line" == *"outbound"* ]]; then
            # Try to extract domain
            local domain=""

            # Match patterns like [domain.com] or domain.com:443
            if [[ "$line" =~ \[([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\] ]]; then
                domain="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}):[0-9]+ ]]; then
                domain="${BASH_REMATCH[1]}"
            fi

            if [[ -n "$domain" && "$domain" != "sing-box" ]]; then
                if [[ "$line" == *"direct"* ]]; then
                    if [[ ! "$seen_direct" =~ "$domain" ]]; then
                        direct_list="${direct_list}• ${domain}\\n"
                        seen_direct="$seen_direct $domain"
                    fi
                elif [[ "$line" == *"proxy"* ]]; then
                    if [[ ! "$seen_proxy" =~ "$domain" ]]; then
                        proxy_list="${proxy_list}• ${domain}\\n"
                        seen_proxy="$seen_proxy $domain"
                    fi
                fi
            fi
        fi
    done < <(tail -200 "$LOG_FILE" 2>/dev/null)

    local result=""
    if [[ -n "$direct_list" ]]; then
        result="📤 Direct:\\n${direct_list}"
    fi
    if [[ -n "$proxy_list" ]]; then
        [[ -n "$result" ]] && result="${result}\\n"
        result="${result}🔒 Proxy:\\n${proxy_list}"
    fi

    if [[ -z "$result" ]]; then
        echo "Ожидание трафика..."
    else
        echo "$result"
    fi
}

if pgrep -x sing-box > /dev/null; then
    recent=$(get_recent_traffic)
    tooltip="VLESS VPN активен\\n\\nDirect: ${DIRECT_DOMAINS}\\n\\nТрафик:\\n${recent}"
    echo "{\"text\": \"󰌾 On\", \"class\": \"connected\", \"tooltip\": \"${tooltip}\"}"
else
    echo "{\"text\": \"󰌾 Off\", \"class\": \"disconnected\", \"tooltip\": \"VPN выключен\"}"
fi
