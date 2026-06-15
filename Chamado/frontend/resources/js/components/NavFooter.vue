<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { SidebarMenu, SidebarMenuItem, SidebarMenuButton } from '@/components/ui/sidebar';
import type { NavItem } from '@/types';

defineProps<{
    items: NavItem[];
}>();
</script>

<template>
    <SidebarMenu>
        <SidebarMenuItem v-for="item in items" :key="item.title">
            <SidebarMenuButton as-child :tooltip="item.title">
                <Link :href="item.href">
                    <component :is="item.icon" v-if="item.icon" />
                    <span class="text-xs">{{ item.title }}</span>
                </Link>
            </SidebarMenuButton>
        </SidebarMenuItem>
    </SidebarMenu>
</template>

