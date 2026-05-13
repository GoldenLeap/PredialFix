<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3';
import { LogOut, Settings, Sun, Moon, Monitor } from 'lucide-vue-next';
import {
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
} from '@/components/ui/dropdown-menu';
import UserInfo from '@/components/UserInfo.vue';
import { useAppearance } from '@/composables/useAppearance';
import { logout } from '@/routes';
import { edit } from '@/routes/profile';
import type { User } from '@/types';

const { appearance, updateAppearance } = useAppearance();

const handleLogout = () => {
    router.flushAll();
};

const themeItems = [
    { label: 'Claro', icon: Sun, value: 'light' },
    { label: 'Escuro', icon: Moon, value: 'dark' },
    { label: 'Sistema', icon: Monitor, value: 'system' },
];

defineProps<Props>();
</script>

<template>
    <DropdownMenuLabel class="p-0 font-normal">
        <div class="flex items-center gap-3 px-1 py-1.5 text-left text-sm">
            <UserInfo :user="user" :show-email="true" />
        </div>
    </DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuGroup>
        <DropdownMenuItem :as-child="true">
            <Link class="block w-full cursor-pointer" :href="edit()" prefetch>
                <Settings class="mr-2 h-4 w-4" />
                Configurações
            </Link>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem>
            <div class="flex items-center justify-between w-full cursor-default">
                <span class="text-sm flex items-center gap-2">
                    <Monitor class="h-4 w-4" />
                    Tema
                </span>
                <div class="flex gap-0.5">
                    <button
                        v-for="item in themeItems"
                        :key="item.value"
                        @click="updateAppearance(item.value)"
                        class="p-1 rounded-md transition-colors"
                        :class="appearance === item.value ? 'bg-neutral-200 dark:bg-neutral-700' : 'hover:bg-neutral-100 dark:hover:bg-neutral-800'"
                    >
                        <component :is="item.icon" class="h-3.5 w-3.5 text-neutral-600 dark:text-neutral-300" />
                    </button>
                </div>
            </div>
        </DropdownMenuItem>
    </DropdownMenuGroup>
    <DropdownMenuSeparator />
    <DropdownMenuItem :as-child="true">
        <Link
            class="block w-full cursor-pointer"
            :href="logout()"
            @click="handleLogout"
            as="button"
            data-test="logout-button"
        >
            <LogOut class="mr-2 h-4 w-4" />
            Sair
        </Link>
    </DropdownMenuItem>
</template>
