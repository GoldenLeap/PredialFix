<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { BookOpen, Calendar, DollarSign, FileText, FolderGit2, LayoutGrid, Package, Settings } from 'lucide-vue-next';
import AppLogo from '@/components/AppLogo.vue';
import NavFooter from '@/components/NavFooter.vue';
import NavMain from '@/components/NavMain.vue';
import NavUser from '@/components/NavUser.vue';
import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
} from '@/components/ui/sidebar';
import { dashboard } from '@/routes';
import type { NavItem } from '@/types';

const mainNavItems: NavItem[] = [
    {
        title: 'Dashboard',
        href: dashboard(),
        icon: LayoutGrid,
    },
    {
        title: 'Chamados',
        href: '/chamados',
        icon: BookOpen,
    },
    {
        title: 'Orçamento',
        href: '/orcamento',
        icon: DollarSign,
    },
    {
        title: 'Materiais',
        href: '/materiais',
        icon: Package,
    },
    {
        title: 'Relatórios',
        href: '/relatorios',
        icon: FileText,
    },
    {
        title: 'Calendário',
        href: '/calendario',
        icon: Calendar,
    },
];

const footerNavItems: NavItem[] = [
    {
        title: 'Configurações',
        href: '/settings/profile',
        icon: Settings,
    },
];
</script>

<template>
    <Sidebar collapsible="icon" variant="inset">
        <SidebarHeader>
            <SidebarMenu>
                <SidebarMenuItem>
                    <SidebarMenuButton size="lg" as-child>
                        <Link :href="dashboard()">
                            <AppLogo />
                        </Link>
                    </SidebarMenuButton>
                </SidebarMenuItem>
            </SidebarMenu>
        </SidebarHeader>

        <SidebarContent>
            <NavMain :items="mainNavItems" />
        </SidebarContent>

        <SidebarFooter>
            <NavFooter :items="footerNavItems" />
            <NavUser />
        </SidebarFooter>
    </Sidebar>
    <slot />
</template>
