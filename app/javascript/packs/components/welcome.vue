<template>
    <div id="welcome">
        <flash-message></flash-message>
        <h1>{{ $t("root.welcome") }}</h1>
        <button @click="createChat()">{{ $t("root.create_chat") }}</button>
        <button @click="joinRandomChat()">{{ $t("root.join_random_chat") }}</button>
        {{ rewriteSessionTokenInLocalStorage() }}
    </div>
</template>

<script>
    export default {
        methods: {
            rewriteSessionTokenInLocalStorage() {
                localStorage.removeItem('session_token')
                localStorage.setItem('session_token', gon.session_token)
            },
            createChat() {
                this.$http.post('/chats',
                    {session_token: gon.session_token}
                ).then(response => {
                    if (response.body.session_token_unique) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                    } else {
                        this.flash(this.$t('flash.session_token_exists'), 'error')
                    }
                });
            },
            joinRandomChat() {
                this.$http.post('/chats/join_random',
                    {session_token: gon.session_token}
                ).then(response => {
                    if (!response.body.session_token_unique) {
                        this.flash(this.$t('flash.session_token_exists'), 'error')
                        return
                    }
                    if (response.body.free_chat_found) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                    } else {
                        this.flash(this.$t('flash.no_empty_chats'), 'warning')
                    }
                });
            }
        }
    }
</script>